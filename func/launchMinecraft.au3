Func _launchMinecraft($selected_profile, $current_profile, $selected_version, $current_version)

   Local $function_name = "Play Minecraft"

   ; Ask for confirmation if changing profile or version
   If $selected_profile <> $current_profile OR $selected_version <> $current_version THEN
	  Local $confirm = MsgBox(4, "Launching Minecraft", "Are you sure you want to launch version " & $selected_version & " with the " & $selected_profile & " profile?")
	  If $confirm > 6 Then
		 Return True
	  EndIf
   EndIf

   ; Check if Minecraft store version is installed
   $result = _checkForeignInstall($MC_AppX_Name, $selected_version)
   Local $installed = $result[0]
   Local $external_install = $result[1]
   Local $version_change = $result[2]

   ; If install location is not $version_dir then it's probable the store version
   ; If is then prompt user to uninsstall it
   If $external_install = True Then
      MsgBox(0, "Error", "There is another version of Minecraft installed on this system!" & @CRLF & @CRLF & "You need to uninstall that version first before you can use this app." & @CRLF & @CRLF & "To uninstall, please use the UNINSTALL MINECRAFT button.")
      return True
   EndIf

   ; If no version is installed then change versions (prompts system to install selected version)
   If $installed = False Then
      ;MsgBox(0, "", "Not installed so version change")
      $version_change = True
   EndIf

   ; Change Version
   ; If different from selected then install different version
   If($version_change==True) Then
      ;MsgBox(0, "", "Version Change")
      If _switchVersion('minecraft', $selected_version) == False Then
         _log("Error Switching Version", $function_name, True)
         MsgBox(48, "Error", "Error Switching Version")
	      Return True
      Else
      ; If profile switched succesfully then update global variable and set data in options.txt file
      $current_version = $selected_version
      IniWrite($options_file, "Data", "current_version", $selected_version)
      EndIf
   EndIf

   ; Changing Profile
   ; - Check if com.mojang is symlink
   ; - If true then delete and make new one to correct profile
   ; - If false then rename com.mojang -> com.mojang.profile_name-1 - Increase number in case becomes more than one of the same
   ; 		- Create SymLink to Profile Dir

   _log("Switch Profile", $function_name)

   If _switchProfile('minecraft', $selected_profile, $current_profile) == False Then
   _log("Error Switching Profile", $function_name, True)
   MsgBox(48, "Error", "Error Switching Profile")
   Return True
   Else
   ; If profile switched succesfully then update global variable and set data in options.txt file
   $current_profile = $selected_profile
   IniWrite($options_file, "Data", "current_profile", $selected_profile)
   EndIf


   ; Launch

   _log("Launching Minecraft", $function_name)
   Local $powershell_command = "explorer.exe shell:AppsFolder\" & $MC_AppX_FamilyName & "!App"
   Local $iReturn = RunWait($powershell_path & " -Command " & $powershell_command, @WindowsDir, @SW_HIDE)

   Return True

EndFunc

