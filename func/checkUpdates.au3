Func _checkUpdates()

   ; If fails / errors then return false = No updates available (Maybe the website changes or goes down in the future, prevent app crashes)

   Local $function_name = "Check for Updates"

   ; Connect to http://www.foxynotail.com/dev/apps/_APPNAME_/versions.json
   Local $versions_url = "http://www.foxynotail.com/dev/apps/" & $app_name & "/versions.json"
   Local $version_data = _INetGetSource($versions_url)

   If @error Then
	  _log("Cannot connect to remote versions file.", $function_name, True)
	  Return False
   EndIf

   ;Decode the JSON_string into a useable object
   Json_Dump($version_data)
   Local $Obj = Json_Decode($version_data)

   Local $i = 0

   Local $latest_version = ""

   While 1

	  $version = json_get($obj, '[' & $i & '].version')

	  If @error OR $version = "" Then
		 ExitLoop
	  ElseIf $version > $latest_version Then
		 $latest_version = $version
	  EndIf
	  $i += 1

   WEnd

   If $latest_version > $app_version Then
	  Return $latest_version
   EndIf

   Return False

EndFunc