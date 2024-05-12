; Check if directory is symbolic link [works for files too]
Func _checkSymLink($directory)

    Local $FILE_ATTRIBUTE_REPARSE_POINT = 0x400

    If Not FileExists($directory) Then

        Return SetError(1, 0, '')

	 EndIf

    $rc = DllCall('kernel32.dll', 'Int', 'GetFileAttributes', 'str', $directory)

    If IsArray($rc) Then

        If BitAND($rc[0], $FILE_ATTRIBUTE_REPARSE_POINT) = $FILE_ATTRIBUTE_REPARSE_POINT Then

            Return True

        EndIf
	 EndIf

    Return False

EndFunc