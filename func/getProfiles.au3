Func _getProfiles()

   Local $array = _FileListToArray($profile_dir, "*", 2, False)
   Return $array

EndFunc