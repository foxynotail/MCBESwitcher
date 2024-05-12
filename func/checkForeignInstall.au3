; Checks if Minecraft is installed elsewhere on the system

Func _checkForeignInstall($appx_name, $selected_version)

    Local $random_string = _randomString(10)
    Local $check_file_name = $random_string
    ; $check_file_name = "_mc-data.txt" ; For testing
    Local $check_file = @TempDir & "\" & $check_file_name
    Local $powershell_command = "Get-AppXPackage " & $appx_name & "* > '" & $check_file & "'"

    Local $installed = False   ; Determines if MC is installed anywhere
    Local $external_install = False ; Determines if MC Version was installed by Store or not by this app
    Local $version_change = False ; Determines if the current installed version is the same as the one being selected for quick launch
    Local $installed_version
    Local $installed_location
    Local $last_line

    ; Result Array [0] = Installed (TRUE|FALSE) [1] = External Install (TRUE|FALSE) [2] = Version Change (TRUE|FALSE)
    Local $result[3]
    $result[0] = False
    $result[1] = False
    $result[2] = False

    ; Create install check file by using PowerShell to see if MinecraftUWP Appx is installed
    Local $iReturn = RunWait($powershell_path & " -Command " & $powershell_command, @ScriptDir, @SW_HIDE)

    ; Get data from check file
    If FileExists($check_file) Then

        ; Check if file is blank (MC is uninstalled)
        Local $data = FileRead($check_file)

        If $data <> "" Then ; File is not blank

            $result[0] = True

            ; Get installed version number
            Local $lines = FileReadToArray($check_file)
            If UBound($lines)-1 > 0 Then

                For $i = 0 To UBound($lines)-1

                    Local $line = $lines[$i]

                    If StringLeft($line, 7) == "Version" Then
                        Local $split = StringSplit($line, ":")
                        Local $installed_version = StringStripWS($split[2], 8)
                    EndIf
                    If StringLeft($line, 15) == "InstallLocation" Then
                        Local $iPos = StringInStr($line, ":")
                        Local $installed_location = StringMid($line, $iPos+1)
                        $installed_location = StringStripWS($installed_location, $STR_STRIPLEADING)

                        ; This can go onto multiple lines if the directory path is long
                        ; So get next lines that don't have the : breaker
                        $last_line = "InstallLocation"

                    Else
                        If $last_line == "InstallLocation" AND StringInStr($line, ":") Then
                            $last_line = ""
                        EndIf
                        If $last_line == "InstallLocation" AND NOT StringInStr($line, ":") Then
                            $installed_location &= StringStripWS($line, $STR_STRIPLEADING)
                        EndIf
                    EndIf

                Next

                If $installed_version <> "" Then
                    ; Check if installed version is installed in the correct directory (not store version)
                    Local $split = StringSplit($installed_location, "\", $STR_NOCOUNT)
                    Local $path = _ArrayToString($split, "\", 0, UBound($split)-2)

                    If($path <> $version_dir) Then
                        ;MsgBox(0, "", $path & @CRLF & $version_dir)
                        $result[1] = True
                    Else
                        ; If its the correct type of install, check if the installed version is different from selected version
                        ; Powershell info uses alternate MC versioning i.e. 1.19.34.0 instead of 1.19.0.34 so need to get actual version number from manifest file instead of directory name

                        Local $selected_version_dir = $version_dir & "\" & $selected_version
                        If NOT FileExists($selected_version_dir) Then
                            ; Selected version not installed
                             $result[2] = True
                        Else 
                            Local $manifest_path = $selected_version_dir & "\AppxManifest.xml"
                            Local $version = _getVersionFromManifest($manifest_path)

                            If($version <> $installed_version) Then
                                ;MsgBox(0, "", "Set Version Change" & @CRLF & $version & @CRLF & $installed_version)
                                $result[2] = True
                            EndIf
                        EndIf
                    EndIf
                EndIf
            EndIf
        EndIf
    EndIf


    If FileExists($check_file) Then
        FileDelete($check_file)
    EndIf

    return $result

EndFunc