; https://www.autoitscript.com/forum/topic/178561-simple-web-downloader-with-progress-bar/
Func _webDownloader($sSourceURL, $sTargetName, $sVisibleName, $sTargetDir = @TempDir, $bProgressOff = True, $iEndMsgTime = 2000, $sDownloaderTitle = "Downloading...")
    ; Declare some general vars
    Local $iMBbytes = 1048576

    ; If the target directory doesn't exist -> create the dir
    If Not FileExists($sTargetDir) Then DirCreate($sTargetDir)


    ; Get download and target info
    Local $sTargetPath = $sTargetDir & "\" & $sTargetName
    
    Local $iFileSize = InetGetSize($sSourceURL)
    Local $hFileDownload = InetGet($sSourceURL, $sTargetPath, $INET_LOCALCACHE, $INET_DOWNLOADBACKGROUND)

    ; Show progress UI
    ProgressOn($sDownloaderTitle, "Downloading " & $sVisibleName, "", -1, -1, $DLG_MOVEABLE)

    ; Keep checking until download completed
    Do
        Sleep(500)

        ; Set vars
        Local $iDLPercentage = Round(InetGetInfo($hFileDownload, $INET_DOWNLOADREAD) * 100 / $iFileSize, 0)
        Local $iDLBytes = Round(InetGetInfo($hFileDownload, $INET_DOWNLOADREAD) / $iMBbytes, 2)
        Local $iDLTotalBytes = Round($iFileSize / $iMBbytes, 2)

        ; Update progress UI
        If IsNumber($iDLBytes) And $iDLBytes >= 0 Then
            ProgressSet($iDLPercentage, $iDLPercentage & "% - Downloaded " & $iDLBytes & " MB of " & $iDLTotalBytes & " MB")
        Else
            ProgressSet(0, "Downloading '" & $sVisibleName & "'")
        EndIf
    Until InetGetInfo($hFileDownload, $INET_DOWNLOADCOMPLETE)

    ; If the download was successfull, return the target location
    If InetGetInfo($hFileDownload, $INET_DOWNLOADSUCCESS) Then
        ProgressSet(100, "Downloading '" & $sVisibleName & "' completed")
        If $bProgressOff Then
            Sleep($iEndMsgTime)
            ProgressOff()
        EndIf
        Return $sTargetPath
    ; If the download failed, set @error and return False
    Else
        Local $errorCode = InetGetInfo($hFileDownload, $INET_DOWNLOADERROR)
        ProgressSet(0, "Downloading '" & $sVisibleName & "' failed." & @CRLF & "Error code: " & $errorCode)
        If $bProgressOff Then
            Sleep($iEndMsgTime)
            ProgressOff()
        EndIf
        SetError(1, $errorCode, False)
    EndIf
EndFunc   ;==>_webDownloader
