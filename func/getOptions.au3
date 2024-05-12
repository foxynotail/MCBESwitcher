Func _getOptions()

    ; Read Ini File Sections and set to global variables

    Global $options_file = @ScriptDir & "\options.txt"
    Local $opt_directiories = IniReadSection($options_file, "Directories")
    _optToArray($opt_directiories)

    Local $opt_data = IniReadSection($options_file, "Data")
    _optToArray($opt_data)

    Local $opt_data = IniReadSection($options_file, "Misc")
    _optToArray($opt_data)

    Local $opt_data = IniReadSection($options_file, "User Accounts")
    _optToArray($opt_data)

    Local $opt_data = IniReadSection($options_file, "Versions")
    _optToArray($opt_data)

    Global $log_dir = @ScriptDir
    Global $log = $log_dir & "\log.txt"
    Global $error_log = $log_dir & "\error_log.txt"

EndFunc


Func _optToArray($oArray)

Local $key, $val

If UBound($oArray) > 1 Then

    For $i = 1 to UBound($oArray) -1

        $key = $oArray[$i][0]
        $val = $oArray[$i][1]

        If $val == "True" OR $val == "true" Then
            $val = True
        EndIf

        If $val == "False" OR $val == "false" Then
            $val = False
        EndIf
        ;MsgBox("", "", "Key: " & $key & " - Val: " & $val)

        ; Sort Wild Cards
        $val = StringReplace($val, "_LOCALAPPDATA_", @LocalAppDataDir)
        $val = StringReplace($val, "_APPDATA_", @AppDataDir)
        $val = StringReplace($val, "_SCRIPTDIR_", @ScriptDir)

        ; Create Global Variable From Key -> Val
        Assign($key, $val, $ASSIGN_FORCEGLOBAL)

    Next
EndIf

EndFunc