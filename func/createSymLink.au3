Func _createSymLink( $qLink, $qTarget, $qIsDirectoryLink = 0 )

    If FileExists($qLink) Then
        SetError(2)
        Return 0
    EndIf

    DllCall("kernel32.dll", "BOOLEAN", "CreateSymbolicLink", "str", $qLink, "str", $qTarget, "DWORD", Hex($qIsDirectoryLink))
    If @error Then
        SetError(1, @extended, 0)
        Return
    EndIf

    Return $qLink

EndFunc