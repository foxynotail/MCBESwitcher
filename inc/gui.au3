; GUI VARS
$inner_width = 960
$inner_height = 760
$margin = 20

If $installed_version == False Then
   $inner_height = $inner_height + 20
EndIf

$width = $inner_width + ($margin*2)
$height = $inner_height + ($margin*2)

$top = $margin
$left = $margin
$bottom = $top + $inner_height
$right = $left + $inner_width

$col = $inner_width/3

$row = 20

Local $sFont = "Courier New"

Opt("GUIOnEventMode", 1)

$hGUI = GUICreate($app_title, $width, $height, -1, -1, $GUI_SS_DEFAULT_GUI)
GUISetOnEvent($GUI_EVENT_CLOSE, "_guiExit")
GUISetIcon ("icon.ico")
GUISetFont(12, $FW_NORMAL, $GUI_FONTNORMAL, $sFont)
GUISetBkColor(0x2d2d2d)
GUICtrlCreatePic("data/bg.jpg", 0, 0, 1000, 800)
GUICtrlSetState(-1 ,$GUI_DISABLE)

$hTop = $top
$hLeft = $left

#include "../gui/gui_profile.au3"

#include "../gui/gui_stable_version.au3"

#include "../gui/gui_preview_version.au3"

Local $versions = _getVersions('stable')

Local $preview_versions = _getVersions('preview')

$play_minecraft_button = GUICtrlCreateButton("", $right-252-15, 300, 252, 52, $BS_ICON)
GUICtrlSetImage (-1, "data/play-minecraft.ico")
GUICtrlSetOnEvent(-1, "_guiPlayMinecraft")
GUICtrlSetTip(-1, "Open currently configured profile and Minecraft version")
GUICtrlSetCursor(-1, 0)

$uninstall_minecraft_button = GUICtrlCreateButton("", $right-252-15, 365, 252, 42, $BS_ICON)
GUICtrlSetImage (-1, "data/uninstall-minecraft.ico")
GUICtrlSetOnEvent(-1, "_guiUninstallMinecraft")
GUICtrlSetTip(-1, "Delete the active Minecraft Installation from your PC")
GUICtrlSetCursor(-1, 0)

$play_preview_button = GUICtrlCreateButton("Play Preview", $right-252-15, 520, 252, 52, $BS_ICON)
GUICtrlSetImage (-1, "data/play-preview.ico")
GUICtrlSetOnEvent(-1, "_guiPlayPreview")
GUICtrlSetTip(-1, "Open currently configured profile and Minecraft Preview version")
GUICtrlSetCursor(-1, 0)

$uninstall_preview_button = GUICtrlCreateButton("", $right-252-15, 585, 252, 42, $BS_ICON)
GUICtrlSetImage (-1, "data/uninstall-preview.ico")
GUICtrlSetOnEvent(-1, "_guiUninstallPreview")
GUICtrlSetTip(-1, "Delete the active Minecraft Preview Installation from your PC")
GUICtrlSetCursor(-1, 0)

$update_button = GUICtrlCreateButton("Check for Updates", $left, 700, 234, 54, $BS_ICON)
GUICtrlSetImage (-1, "data/check-for-updates.ico")
GUICtrlSetOnEvent(-1, "_guiCheckUpdates")
GUICtrlSetTip(-1, "Click to check if there are any new versions")
GUICtrlSetCursor(-1, 0)

$help_button = GUICtrlCreateButton("Help", $right-234, 700, 234, 54, $BS_ICON)
GUICtrlSetImage (-1, "data/help.ico")
GUICtrlSetOnEvent(-1, "_guiHelp")
GUICtrlSetTip(-1, "Click to view help text")
GUICtrlSetCursor(-1, 0)

$web_label = GUICtrlCreateLabel($app_link, $left, 770, 500, $row, $SS_LEFT)
GUICtrlSetFont(-1, 10, 400 ,0)
GUICtrlSetColor(-1, 0xa1d6fc)
GUICtrlSetOnEvent(-1, "_guiWebLink")
GUICtrlSetCursor(-1, 0)

$copyright_label = GUICtrlCreateLabel($app_copyright, $right-400, 770, 400, $row, $SS_RIGHT)
GUICtrlSetFont(-1, 10)
GUICtrlSetColor(-1, 0xFFFFFF)

GUISetState(@SW_SHOW)

#include "../gui/update.au3"
#include "../gui/help.au3"

Func _guiExit()
   GUIDelete($hGUI)
   GUIDelete($hGUI_update)
   Exit
EndFunc

Func _guiPlayMinecraft()

   Global $selected_profile = GUICtrlRead($profile_box)
   Global $selected_mc_version = GUICtrlRead($mc_version_box)
   $selected_mc_version = StringReplace($selected_mc_version, " [Installed]", "")

   If $selected_mc_version == "" Then
	  MsgBox(48, "Error", "You must choose a version first")
   Else
	      GUICtrlSetState($play_minecraft_button, $GUI_DISABLE)
	      GUICtrlSetState($uninstall_minecraft_button, $GUI_DISABLE)
         If _launchMinecraft($selected_profile, $current_profile, $selected_mc_version, $current_version) == True Then
            _refreshData()
            GUICtrlSetState($play_minecraft_button, $GUI_ENABLE)
            GUICtrlSetState($uninstall_minecraft_button, $GUI_ENABLE)
         EndIf
   EndIf

EndFunc

Func _guiPlayPreview()

   Global $selected_profile = GUICtrlRead($profile_box)
   Global $selected_preview_version = GUICtrlRead($preview_version_box)
   $selected_preview_version = StringReplace($selected_preview_version, " [Installed]", "")

   If $selected_preview_version == "" Then
	   MsgBox(48, "Error", "You must choose a preview version first")
   Else
	   GUICtrlSetState($play_preview_button, $GUI_DISABLE)
	   GUICtrlSetState($uninstall_preview_button, $GUI_DISABLE)
	   If _launchPreview($selected_profile, $current_profile, $selected_preview_version, $current_preview_version) == True Then
         _refreshData()
		   GUICtrlSetState($play_preview_button, $GUI_ENABLE)
		   GUICtrlSetState($uninstall_preview_button, $GUI_ENABLE)
	   EndIf
   EndIf

EndFunc

Func _guiUninstallMinecraft() 

	GUICtrlSetState($uninstall_minecraft_button, $GUI_DISABLE)
	GUICtrlSetState($play_minecraft_button, $GUI_DISABLE)
	If _uninstallMinecraft() == True Then
      _refreshData()
		GUICtrlSetState($uninstall_minecraft_button, $GUI_ENABLE)
	   GUICtrlSetState($play_minecraft_button, $GUI_ENABLE)
	EndIf

EndFunc

Func _guiUninstallPreview() 

	GUICtrlSetState($uninstall_preview_button, $GUI_DISABLE)
	GUICtrlSetState($play_preview_button, $GUI_DISABLE)
	If _uninstallPreview() == True Then
      _refreshData()
		GUICtrlSetState($uninstall_preview_button, $GUI_ENABLE)
	   GUICtrlSetState($play_preview_button, $GUI_ENABLE)
	EndIf
EndFunc

Func _guiCheckUpdates()

   Local $uResult = _checkUpdates()
   If $uResult == False Then
	  MsgBox("", "Updates", "There are no updates available")

   Else
	  ;MsgBox("", "Updates", "Version " & $uResult & " is available to download!" & @CRLF & " Link: " )
	  GUICtrlSetData($update_version_label, "Version: " & $uResult)
	  GUICtrlSetData($update_version_hidden_label, $uResult)
	  GUISetState(@SW_DISABLE, $hGUI)
	  GUISetState(@SW_SHOW, $hGUI_update)
	  ; Get Update
   EndIf

EndFunc

Func _guiHelp()
   GUISetState(@SW_DISABLE, $hGUI)
   GUISetState(@SW_SHOW, $hGUI_help)
EndFunc

Func _guiWebLink()
   ShellExecute($app_link)
EndFunc
