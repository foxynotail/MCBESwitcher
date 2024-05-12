; #FUNCTION# ====================================================================================================================
; Name...........: _GetReparseTarget
; Description....: Resolves a Reparse-Point (Junction, Symbolic Link or Mount Point) to its target and returns that destination path
; Syntax.........: _GetReparseTarget ( $sLink[, $AbsPath = True] )
; Parameters.....: $sLink - Full path to a Reparse-Point object
;                            $AbsPath - Return an absolute path when link ID type is 2 (embedded relative path Symbolic Link)
;
; Return values..: Success - The path/filename of the target location
;
;                                    @extended returns the ID/type of the Reparse-Point itself:
;                                    0 - Unknown/Unresolved
;                                    1 - Symbolic Link (embedded Absolute-Path)
;                                    2 - Symbolic Link (embedded Relative-Path) - primary return value will be an absolute path via the $sLink container (set $AbsPath = False to return the relative path)
;                                    3 - Junction Point
;                                    4 - Mount Point - primary return value will be the Globally Unique Identifier (GUID) as \\?\Volume{xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx}\
;
;                            Failure - Empty string ("") and sets the @error flag:
;                                    1 - $sLink Not Found
;                                    2 - Unable to Open $sLink
;                                    3 - $sLink is not a Reparse-Point
;                                    4 - Unresolveable (Corrupted Tag / No Target details)
;
; Author.........: Kilmatead
; Modified.......:
; Remarks........: @Extended may still contain a valid ID even if the link itself failed resolution
;
;                        The $AbsPath parameter has no effect beyond relative path Symbolic Links (ID 2)
;
;                        No check is made to see if the resolved target folder or file actually exists, as even though the target-destination may have been renamed/removed or is temporarily
;                        unavailable, that doesn't invalidate the data integrity of the reparse-tag itself, especially when it may contain relative-path references
;
;                        Permission-Free access is used to open the link so as to resolve even System Links (as found in Vista+) - this can be misleading, as it does not indicate that using
;                        $sLink directly in the script outside of this function will likely fail as System Links have ACL's which deny access to everyone
;
; Related........:
; Link...........:
; Example........:
; ===============================================================================================================================

#include <APIConstants.au3>
#include <File.au3>
#include <WinAPIEx.au3>

Func _GetReparseTarget($sLink, $AbsPath = True)
    Local Enum $ID_UNKNOWN, $ID_SYMLINK, $ID_SYMLINK_RELATIVE, $ID_JUNCTION, $ID_MOUNT_POINT
    Local Enum $NOTFOUND = 1, $ACCESSDENIED, $NOTREPARSE, $NOTRESOLVED

    Local $tFindData = DllStructCreate($tagWIN32_FIND_DATA)
    Local $hFile = _WinAPI_FindFirstFile($sLink, DllStructGetPtr($tFindData)) ; Retrieve the attributes / verify existence / obtain the ReparseTag identifier
    If @error Then Return SetError($NOTFOUND, $ID_UNKNOWN, "")
    _WinAPI_FindClose($hFile)

    If BitAND(DllStructGetData($tFindData, "dwFileAttributes"), $FILE_ATTRIBUTE_REPARSE_POINT) Then
        Local Const $IO_REPARSE_TAG_SYMLINK = 0xA000000C
        Local Const $IO_REPARSE_TAG_MOUNT_POINT = 0xA0000003

        Local $Ret = "", $TypeID = $ID_UNKNOWN
        Local $Tag = _WinAPI_LoWord(DllStructGetData($tFindData, "dwReserved0"))

        Local $tREPARSE_GUID_DATA_BUFFER = _
                "dword ReparseTag;" & _
                "word ReparseDataLength;" & _
                "word Reserved; " & _
                "word SubstituteNameOffset;" & _
                "word SubstituteNameLength;" & _
                "word PrintNameOffset;" & _
                "word PrintNameLength;"

        Select
            Case BitAND($Tag, $IO_REPARSE_TAG_SYMLINK)
                $TypeID = $ID_SYMLINK
                $tREPARSE_GUID_DATA_BUFFER &= "dword Flags;" ; Convert (default) struct MountPointReparseBuffer to struct SymbolicLinkReparseBuffer

            Case BitAND($Tag, $IO_REPARSE_TAG_MOUNT_POINT)
                $TypeID = $ID_JUNCTION

            Case Else
                Return SetError($NOTRESOLVED, $ID_UNKNOWN, "")
        EndSelect

        $hFile = _WinAPI_CreateFileEx($sLink, $OPEN_EXISTING, 0, BitOR($FILE_SHARE_READ, $FILE_SHARE_WRITE, $FILE_SHARE_DELETE), _ ; dwDesiredAccess 0 (permission-free)
                BitOR($FILE_FLAG_BACKUP_SEMANTICS, $FILE_FLAG_OPEN_REPARSE_POINT))
        If @error Then Return SetError($ACCESSDENIED, $TypeID, "")

        Local $RGDB = DllStructCreate($tREPARSE_GUID_DATA_BUFFER & "wchar PathBuffer[4096]")
        _WinAPI_DeviceIoControl($hFile, $FSCTL_GET_REPARSE_POINT, 0, 0, DllStructGetPtr($RGDB), DllStructGetSize($RGDB))

        If Not @error Then
            Local Const $SYMLINK_FLAG_RELATIVE = 0x00000001
            Local Const $SIZEOF_WCHAR = 2

            Local $sBuffer = DllStructGetData($RGDB, "PathBuffer") ; Buffer "may" contain multiple strings "in any order" [MSDN]...
            Local $iOffset = DllStructGetData($RGDB, "SubstituteNameOffset") / $SIZEOF_WCHAR
            Local $iLength = DllStructGetData($RGDB, "SubstituteNameLength") / $SIZEOF_WCHAR

            $Ret = StringMid($sBuffer, 1 + $iOffset, $iLength) ; ...so always extract SubstituteName (despite its moniker) as the path-proper

            If StringLeft($Ret, 2) = "\?" Then $Ret = "\\" & StringMid($Ret, 3) ; DeviceIoControl loves substituting \??\ for more common \\?\, so we substitute it right back

            If $TypeID = $ID_SYMLINK And DllStructGetData($RGDB, "Flags") = $SYMLINK_FLAG_RELATIVE Then
                $TypeID = $ID_SYMLINK_RELATIVE
                If $Ret <> "" And $AbsPath Then $Ret = _PathFull($Ret, StringLeft($sLink, StringInStr($sLink, "\", 0, -1))) ; Convert to absolute path based from $sLink container
            EndIf

            Select ; Regulate possible mapped/unmapped UNC prefix genera or verify Mounted Volume ID by format
                Case StringRegExp($Ret, "(?i)\\Volume\{[a-f\d]{8}-([a-f\d]{4}-){3}[a-f\d]{12}\}\\$") ; "\Volume{GUID}\"
                    $TypeID = $ID_MOUNT_POINT
                Case StringLeft($Ret, 8) = "\\?\UNC\"
                    $Ret = StringReplace($Ret, "?\UNC\", "", 1) ; "\\?\UNC\server\share" -> "\\server\share"
                Case StringLeft($Ret, 4) = "\\?\" And StringMid($Ret, 6, 1) = ":"
                    $Ret = StringTrimLeft($Ret, 4) ; "\\?\C:\FolderObject" -> "C:\FolderObject"
            EndSelect
        EndIf

        _WinAPI_CloseHandle($hFile)
        $RGDB = 0

        If $Ret = "" Then Return SetError($NOTRESOLVED, $TypeID, "")

        Return SetExtended($TypeID, $Ret)
    EndIf

    Return SetError($NOTREPARSE, $ID_UNKNOWN, "")
EndFunc