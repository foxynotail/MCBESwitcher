Func _checkInstalled($appx_name)

   Local $function_name = "Check Installed"

   Local $random_string = _randomString(10)
   Local $check_file_name = "data\" & $random_string & ".txt"
   Local $check_file = @ScriptDir & "\" & $check_file_name
   Local $powershell_command = "Get-AppXPackage " & $appx_name & " > " & $check_file_name

   Local $installed = False

   ; Create install check file by using PowerShell to see if MinecraftUWP Appx is installed
   Local $iReturn = RunWait($powershell_path & " -Command " & $powershell_command, @ScriptDir, @SW_HIDE)

   If FileExists($check_file) Then

		; Check if file is blank (MC is uninstalled)
		Local $data = FileRead($check_file)
		If $data == "" Then ; File is not blank
			$installed = False
		Else

			$installed = True

			; Get installed version number
			Local $lines = FileReadToArray($check_file)
			If UBound($lines)-1 > 0 Then

				For $i = 0 To UBound($lines)-1

					Local $line = $lines[$i]
					If StringLeft($line, 7) == "Version" Then
						Local $split = StringSplit($line, ":")
						$installed = StringStripWS($split[2], 8)
					EndIf

				Next

			EndIf
		EndIf

   EndIf

   If FileExists($check_file) Then
	  	FileDelete($check_file)
   EndIf

   Return $installed

EndFunc