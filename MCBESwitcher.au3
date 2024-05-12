#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.5
 Author:         FoxyNoTail

 Script Function:
	Minecraft Version Switcher+.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here

; Step One
; Drop down for Profile - @scriptDir\Profiles
; Drop down for version - List from @ScriptDir\MCLauncher\

; Profiles
; - DEFAULT: Use standard com.mojang files
; - Standard: Profiles\Standard
; - RTX: Profiles\RTX
; - BETA: Profiles\BETA

; Changing Profile
; - Check if com.mojang is symlink
; - If true then delete and make new one to correct profile
; - If false then rename com.mojang -> com.mojang.profile_name-1 - Increase number in case becomes more than one of the same
; 		- Create SymLink to Profile Dir

; Changing Version
; Check current_version.txt to see which version was run last
; If same then just launch
; If different then...
; - Copy C:\Users\foxynotail\AppData\Local\Packages\Microsoft.MinecraftUWP_8wekyb3d8bbwe to temp folder
; - PS Get-AppxPackage Microsoft.MinecraftUWP_8wekyb3d8bbwe | Remove-AppxPackage
; - Copy temp folder back
; - PS Add-AppxPackage -Path link_to_manifest.xml -Register

; NEW NOV 2022
; Download https://fxnt.net/_mc-versions/mc-versions.json to local folder on startup



#include "inc/init.au3"
#include "inc/version.au3"

Global $app_copyright = "Copyright © 2022, FoxyNoTail"
Global $app_link = "https://foxynotail.com"
Global $app_name = "MCBESwitcher+"
Global $app_dl = "https://foxynotail.com/software/"

Global $MC_AppX_Name = "Microsoft.MinecraftUWP"
Global $MC_AppX_FamilyName = "Microsoft.MinecraftUWP_8wekyb3d8bbwe"
Global $MC_Preveiw_AppX_Name = "Microsoft.MinecraftWindowsBeta"
Global $MC_Preview_AppX_FamilyName = "Microsoft.MinecraftWindowsBeta_8wekyb3d8bbwe"

Global $app_title = $app_name & " " & $app_version
If $app_stable < 1 Then
   $app_title &= " [DEV]"
EndIf

; Check if already open, if open then alert
If WinExists($app_title) Then
   MsgBox(48, "Alert", $app_name & " is already open")
   Exit
EndIf

; Check if MC is installed already
Global $installed_version = _checkInstalled($MC_AppX_Name) ; Returns False if not installed or version number if installed
Global $installed_preview_version = _checkInstalled($MC_Preveiw_AppX_Name) ; Returns False if not installed or version number if installed

; Download latest versions
Global $REMOTE_VERSIONS_LIST = "https://fxnt.net/_mc-versions/mc-versions.min.json"
Local $dateDiff = _DateDiff('d', $last_updated, _NowCalc())
If $dateDiff>1 Then
   ; Download remote versions file
   _webDownloader($REMOTE_VERSIONS_LIST, 'mc-versions.json', 'mc-versions.json', @ScriptDir, false)
   If @error Then 
      MsgBox(48, "Error", "Error updating Minecraft verions list from remote url")
      _log("Error Updating Verions List", "Initialise", true)
      ProgressOff()
   Else 
      ; Update last download
      IniWrite($options_file, "Versions", "last_updated", " " & _NowCalc())
      _log("Verions List Updated", "Initialise")
      ProgressOff()
   EndIf
EndIf

#include "inc/gui.au3"

Global $selected_profile = $current_profile
Global $selected_version = $current_version

; Loop until the user exits.
Global $fHover = False

While 1
   $aInfo = GUIGetCursorInfo($hGUI)
   $idHover = $aInfo[4]
   switch $idHover
      case $play_minecraft_button
         GUICtrlSetImage($play_minecraft_button, 'data/play-minecraft-hover.ico')
      case $uninstall_minecraft_button
         GUICtrlSetImage($uninstall_minecraft_button, 'data/uninstall-minecraft-hover.ico')
      case $play_preview_button
         GUICtrlSetImage($play_preview_button, 'data/play-preview-hover.ico')
      case $uninstall_preview_button
         GUICtrlSetImage($uninstall_preview_button, 'data/uninstall-preview-hover.ico')
      case $update_button
         GUICtrlSetImage($update_button, 'data/check-for-updates-hover.ico')
      case $help_button
         GUICtrlSetImage($help_button, 'data/help-hover.ico')
      case Else
         GUICtrlSetImage($play_minecraft_button, 'data/play-minecraft.ico')
         GUICtrlSetImage($uninstall_minecraft_button, 'data/uninstall-minecraft.ico')
         GUICtrlSetImage($play_preview_button, 'data/play-preview.ico')
         GUICtrlSetImage($uninstall_preview_button, 'data/uninstall-preview.ico')
         GUICtrlSetImage($update_button, 'data/check-for-updates.ico')
         GUICtrlSetImage($help_button, 'data/help.ico')
   EndSwitch
WEnd

