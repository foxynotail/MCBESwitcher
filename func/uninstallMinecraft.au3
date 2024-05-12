Func _uninstallMinecraft()

   Local $function_name = "Uninstall Minecraft"

   ; Check if installed
   $installed = _checkInstalled($MC_AppX_Name)
   If $installed = False Then
        MsgBox(0, "Minecraft not Installed", "Minecraft is not installed on this PC")
        return True
   EndIf

   ; Ask for confirmation
   Local $text = "Are you sure you want to delete Minecraft?" & @CRLF & @CRLF
   $text &= "This will delete Minecraft for All Users on this PC." & @CRLF & @CRLF

   $text &= "# DEFAULT MINECRAFT DIRECTORY - WILL BE DELETED #" & @CRLF
   $text &= "Location: " & $mc_dir & @CRLF
   $text &= "All worlds, packs and files stored in the default directory will be deleted." & @CRLF & @CRLF

   
   $text &= "# PROFILE DIRECTORY - WILL BE SAFE #" & @CRLF
   $text &= "Location: " & $profile_dir & @CRLF

   $text &= "Your worlds, settings and packs stored inside of your Profile directory will not be affected" & @CRLF & @CRLF
   $text &= "This operation cannot be undone!" & @CRLF

   Local $confirm = MsgBox(4, "Uninstall Minecraft", $text)
   If $confirm > 6 Then
	  Return True
   EndIf

   _log("Uninstalling Minecraft", $function_name)

   GUISetCursor(15, 1)

    ; Close Minecraft first
    If ProcessExists("Minecraft.Windows.exe") Then
	    ProcessClose("Minecraft.Windows.exe")
    EndIf
   
   Local $powershell_command = "Get-AppxPackage " & $MC_AppX_Name & " | Remove-AppxPackage -AllUsers"
   Local $iReturn = RunWait($powershell_path & " -Command " & $powershell_command, @WindowsDir , @SW_HIDE)

   GUISetCursor(2, 0 )

   Return True

EndFunc

