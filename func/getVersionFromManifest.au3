Func _getVersionFromManifest($manifest_file)

    Local $version

    If FileExists($manifest_file) Then

        Local $lines = FileReadToArray($manifest_file)
        If UBound($lines)-1 > 0 Then


            For $i = 0 To UBound($lines)-1
                Local $line = $lines[$i] & StringStripWS($lines[$i], $STR_STRIPLEADING)
                If StringInStr($line, "<Identity", 0, 1) Then         
                    $iPos = StringInStr($line, "Version=", 0)
                    Local $version = StringMid($line, $iPos+StringLen("Version=")+1)
                    $iPos = StringInStr($version, '"')
                    $version = StringLeft($version, $iPos-1)
                EndIf

            Next

        EndIf


    Else

        ; Error Version Manifest File Doesn't Exist
        _log("E"&$e&". AppxManifest.xml file not found", $function_name, true)
        $e+=1
        MsgBox(48, "Error", "Required files not found.")
        Return False

    EndIf
    return $version
EndFunc

Func _checkIsPreviewFromManifest($manifest_file)

    Local $preview = False

    If FileExists($manifest_file) Then

        Local $lines = FileReadToArray($manifest_file)
        If UBound($lines)-1 > 0 Then


            For $i = 0 To UBound($lines)-1
                Local $line = $lines[$i] & StringStripWS($lines[$i], $STR_STRIPLEADING)
                If StringInStr($line, "<Identity", 0, 1) Then         
                    $iPos = StringInStr($line, "Name=", 0)
                    Local $string = StringMid($line, $iPos+StringLen("Name=")+1)
                    $iPos = StringInStr($string, '"')
                    $string = StringLeft($string, $iPos-1)
                    If $string = "Microsoft.MinecraftWindowsBeta" Then
                        $preview = True
                    EndIf
                EndIf

            Next

        EndIf

    EndIf
    return $preview
EndFunc