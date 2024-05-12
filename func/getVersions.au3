Func _getVersions($type)

   $search_term = "Minecraft-*"

   Local $result = _FileListToArray($version_dir, $search_term, 2, False)
   
   Local $array[1]
   If UBound($result) > 1 Then

      For $i=1 To UBound($result)-1

         ; Check each version manifest file to determine if stable or preview
         Local $directory = $version_dir & "\" & $result[$i]
         Local $manifest_file = $directory & "\AppxManifest.xml"
         $preview = _checkIsPreviewFromManifest($manifest_file)

         If $type = 'stable' AND $preview == False Then

            _ArrayAdd($array, $result[$i])

         ElseIf $type = 'preview' AND $preview == True Then

            _ArrayAdd($array, $result[$i])

         EndIf

      Next

   EndIf

   Return $array


EndFunc

Func _getDevVersions()

   $search_term = "Minecraft-*"

   Local $result = _FileListToArray($version_dir, $search_term, 2, False)
   
   Local $array[1]
   If UBound($result) > 1 Then

      For $i=1 To UBound($result)-1

         ; Check each version manifest file to determine if stable or preview
         Local $directory = $version_dir & "\" & $result[$i]
         Local $manifest_file = $directory & "\AppxManifest.xml"
         $version = _getVersionFromManifest($manifest_file)
         _ArrayAdd($array, $version)

      Next

   EndIf

   Return $array


EndFunc

Func _getWebVersions($type)

   ;$url="https://fxnt.net/_mc-versions/mc-versions.json"
   ;$data = _INetGetSource($url)

   $data = FileRead($versions_file)
   $object = json_decode($data)

   ; Load installed versions
   Local $versions = _getDevVersions()

   Local $array[1]
   Local $item_type
   Local $item_name
   If UBound($object) > 1 Then
      For $i=1 To UBound($object) - 1
         $item_type = json_get($object, '[' & $i & '][0]')
         $item_name = json_get($object, '[' & $i & '][1]')
         $item_version = json_get($object, '[' & $i & '][4]')
         
         If @error Then ExitLoop
         IF $item_type = $type Then
            ; Check if version is installed
            Local $exists = _ArraySearch($versions, $item_version)
            IF $exists > -1 Then
               $item_name = $item_name & " [Installed]"
            EndIf
            ; Add to array
            _ArrayAdd($array, $item_name)
         EndIf
      Next
   EndIf

   Return $array

EndFunc