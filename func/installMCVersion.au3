Func checkVersionInstalled($version)


    $version = StringReplace($version, " [Installed]", "")

    ; Need to convert $version 'Minecraft-1.19.40.1' to dev_version
    $data = FileRead($versions_file)
    $object = json_decode($data)

    Local $dev_version = 0
    Local $item_version
    Local $item_name
    If UBound($object) > 1 Then
        For $i=1 To UBound($object) - 1
            $item_name = json_get($object, '[' & $i & '][1]')
            $item_version = json_get($object, '[' & $i & '][4]')
            
            If @error Then ExitLoop
            IF $version = $item_name Then
                ; ;MsgBox("", "", $version & " - " & $item_name)
                $dev_version = $item_version
                ExitLoop
            EndIf
        Next
    EndIf
    
    ; Load installed versions
    Local $local_versions = _getDevVersions()
    Local $exists = false
    If UBound($local_versions) > 1 Then
        For $i=1 To UBound($local_versions) - 1
            ; MsgBox("", "", $local_versions[$i] & " - " & $dev_version)
        
            IF $local_versions[$i] = $dev_version Then
            
                $exists = true
                ExitLoop
                
            EndIf
        Next
    EndIf
    If $exists = true Then 
        return 0
    Else 
        Return $dev_version
    EndIf


EndFunc

Func downloadVersion($version)

    $data = FileRead($versions_file)
    $object = json_decode($data)

    Local $item_ver
    Local $item_id
    Local $item_name
    Local $updateID
    If UBound($object) > 1 Then
        For $i=1 To UBound($object) - 1
            $item_name = json_get($object, '[' & $i & '][1]')
            $item_id = json_get($object, '[' & $i & '][2]')
            $item_ver = json_get($object, '[' & $i & '][4]')
            
            If @error Then ExitLoop
            IF $version = $item_ver Then
                ExitLoop
            EndIf
        Next
    EndIf
    ; MsgBox("", "", $version & " - " & $item_ver & " - " & $item_id)
    Local $url = getDownloadUrl($item_id)
    ;MsgBox("", "", "Link: " & $url)

    Local $file_name = $item_name & ".zip"
    Local $tmp_dir = @TempDir & "\MCDownload"

    $dl_file = _webDownloader($url, $file_name, $item_name, $tmp_dir, false)
    
    If $dl_file Then
        ProgressSet(100, "This can take a few minutes. Please wait...", "Extracting " & $item_name)
        ; Extract Zip to local dir

        ; Extract with Powershell
        Local $sSourceFile = $tmp_dir & "\" & $file_name
        Local $sDestFolder = $version_dir & "\" & $item_name
        
        Local $powershell_command = "Expand-Archive -LiteralPath '" & $sSourceFile & "' -DestinationPath '" & $sDestFolder & "'"

        Local $CmdPid = RunWait($powershell_path & " -Command " & $powershell_command, @ScriptDir, @SW_SHOW)

        ;Local $zip = _Zip_UnzipAll($dl_file, $sDestFolder, 272)
        ;If @error Then 
        ;    MsgBox("", "", "Error extracting files: " & @error)
        ;    ProgressSet(0, "Extraction failed" & @CRLF & "Exit code: " & $zip)
        ;    Return false
        ;EndIf
        ; Remove AppX file
        FileDelete($sDestFolder & "\AppxSignature.p7x")
        
        ProgressSet(100, "Extraction completed")
        Sleep(3000)
        ProgressOff()
        FileDelete($dl_file)
    Else
        ProgressOff()
    EndIf
    return true

EndFunc

Func getDownloadUrl($UpdateID)
    Local $url
    Local $response = requestInfo($UpdateID)
    ;MsgBox("", "", "Response: " & $response)

    If $response == 0 Then 
        Return false
    EndIf
    _FileCreate("data/Temp")
    FileWrite("data/Temp",$response)

    Local $oXML = ObjCreate("Microsoft.XMLDOM")
    $oXML.load("data/Temp")

    Local $links = $oXML.SelectNodes("//")

    For $link In $links

        ;MsgBox("", "Links", $link.text)
        Local $check = StringLeft($link.text, StringLen("http://tlu.dl"))
        If $check = "http://tlu.dl" Then
            $url = $link.text
            ; MsgBox("", "Link", $link.text)
            ExitLoop
        EndIf

    Next
    FileDelete("data/Temp")
    return $url

EndFunc

Func requestInfo($UpdateID)
    
    Const $HTTP_STATUS_OK = 200

    Local $XMLHeader = '<s:Header><a:Action>http://www.microsoft.com/SoftwareDistribution/Server/ClientWebService/GetExtendedUpdateInfo2</a:Action><a:MessageID>urn:uuid:0ffc5961-414a-4019-9c0f-9247281674d4</a:MessageID><a:To s:mustUnderstand="1">https://fe3.delivery.mp.microsoft.com/ClientWebService/client.asmx</a:To><o:Security s:mustUnderstand="1" xmlns:o="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd"><wuws:WindowsUpdateTicketsToken wsu:id="ClientMSA" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd" xmlns:wuws="http://schemas.microsoft.com/msus/2014/10/WindowsUpdateAuthorization"><TicketType Name="AAD" Version="1.0" Policy="MBI_SSL"></TicketType></wuws:WindowsUpdateTicketsToken></o:Security></s:Header>'

    Local $XML = '<s:Envelope xmlns:a="http://www.w3.org/2005/08/addressing" xmlns:s="http://www.w3.org/2003/05/soap-envelope">' & $XMLHeader & '<s:Body><GetExtendedUpdateInfo2 xmlns="http://www.microsoft.com/SoftwareDistribution/Server/ClientWebService"><updateIDs><UpdateIdentity><UpdateID>' & $UpdateID & '</UpdateID><RevisionNumber>1</RevisionNumber></UpdateIdentity></updateIDs><infoTypes><XmlUpdateFragmentType>FileUrl</XmlUpdateFragmentType></infoTypes></GetExtendedUpdateInfo2></s:Body></s:Envelope>'

    $sURL = 'https://fe3.delivery.mp.microsoft.com/ClientWebService/client.asmx'
    Local $oHTTP = ObjCreate("WinHttp.WinHttpRequest.5.1")

    $oHTTP.Open("POST", $sURL, False)
    If (@error) Then Return 0

    $oHTTP.SetRequestHeader("Content-Type", "application/soap+xml; charset=utf-8")
    $oHTTP.SetRequestHeader("User-Agent", "Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.1.1) Gecko/20061204 Firefox/2.0.0.1")
    $oHTTP.SetRequestHeader("Content-Length", StringLen($XML))

    $oHTTP.Send($XML)
    If (@error) Then Return 0

    If ($oHTTP.Status <> $HTTP_STATUS_OK) Then Return 0
    ; MsgBox("", "Status", $oHTTP.Status)

    Return $oHTTP.responseText

EndFunc