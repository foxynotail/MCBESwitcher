Local $version_file = @ScriptDir & "\version.json"
Local $version_data = FileRead($version_file)
If @error Then
   MsgBox(48, "Error", "Version File Not Found")
   Exit
EndIf

;Decode the JSON_string into a useable object
Json_Dump($version_data)
Local $Obj = Json_Decode($version_data)
Global $app_version = json_get($obj, '[0].version')
Global $app_stable = json_get($obj, '[0].stable')
Global $app_id = json_get($obj, '[0].uuid')