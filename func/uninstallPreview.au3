Func _uninstallPreview()

   Local $function_name = "Uninstall Minecraft Preview"

   ; Check if installed
   $installed = _checkInstalled($MC_Preveiw_AppX_Name)
   If $installed = False Then
        MsgBox(0, "Minecraft Preview not Installed", "Minecraft Preview is not installed on this PC")
        return False
   EndIf

   ; Ask for confirmation
   Local $text = "Are you sure you want to delete Minecraft Preview?" & @CRLF & @CRLF
   $text &= "This will delete Minecraft Preview for All Users on this PC." & @CRLF & @CRLF

   $text &= "# DEFAULT MINECRAFT PREVIEW DIRECTORY - WILL BE DELETED #" & @CRLF
   $text &= "Location: " & $preview_dir & @CRLF
   $text &= "All worlds, packs and files stored in the default directory will be deleted." & @CRLF & @CRLF

   
   $text &= "# PROFILE DIRECTORY - WILL BE SAFE #" & @CRLF
   $text &= "Location: " & $profile_dir & @CRLF

   $text &= "Your worlds, settings and packs stored inside of your Profile directory will not be affected" & @CRLF & @CRLF
   $text &= "This operation cannot be undone!" & @CRLF

   Local $confirm = MsgBox(4, "Uninstall Minecraft Preview", $text)
   If $confirm > 6 Then
	  Return False
   EndIf

   _log("Uninstalling Minecraft Preview", $function_name)

   GUISetCursor(15, 1)

    ; Close Minecraft first
    If ProcessExists("Minecraft.Windows.exe") Then
	    ProcessClose("Minecraft.Windows.exe")
    EndIf
   
   Local $powershell_command = "Get-AppxPackage " & $MC_Preveiw_AppX_Name & " | Remove-AppxPackage -AllUsers"
   Local $iReturn = RunWait($powershell_path & " -Command " & $powershell_command, @WindowsDir , @SW_HIDE)

   GUISetCursor(2, 0 )

   Return True

EndFunc


