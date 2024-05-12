Func _switchProfile($type, $selected_profile, $current_profile)

	Local $function_name = "Switch Profile"
	Local $n = 0, $e = 0

	Local $selected_profile_dir = $profile_dir & "\" & $selected_profile

		If $type == 'minecraft' Then
			Local $working_dir = $mc_dir
		Else
			Local $working_dir = $preview_dir
	EndIf

	; Set permissions of Profile folder just incase it's not good so MC can access it
	Local $perms_command = 'icacls "' & $selected_profile_dir & '" /grant *' & $mc_user & ':(OI)(CI)F'
	RunWait(@ComSpec & " /c " & $perms_command, "", @SW_HIDE)
	Local $perms_command = 'icacls "' & $selected_profile_dir & '" /grant *' & $preview_user & ':(OI)(CI)F'
	RunWait(@ComSpec & " /c " & $perms_command, "", @SW_HIDE)

	; NEW
	; Need to check if the current symlink is correct profile as it can get stuck


	; # Switch Profiles
	; Check if current com.mojang is a symbolic link (is not default profile)
	If _checkSymLink($working_dir) == True Then   ; True = Symbolic Link | False = Standard Directory

		_log("N"&$n&". MC Dir is a Symbolic Link", $function_name)
		$n+=1		

		; Check which folder com.mojang is connected to
		Local $target_dir = _GetReparseTarget($mc_dir)
		$split = StringSplit($target_dir, "\", $STR_NOCOUNT)
		Local $target_profile = _ArrayToString($split, "\", UBound($split)-1)

		; If is connected to $selected_profile then do nothin
		If $target_profile == $selected_profile Then

			_log("N"&$n&". MC Dir is already connected to the right profile", $function_name)
			$n+=1

		Else 
			; If not connected to $selected_profile then break current link and relink
			; If is symbolic link then delete and create new, or if switching to default, don't create sym link, rename com.mojang.default to com.mojang
			If DirRemove($working_dir) < 1 Then

				; Error removing symbolic link
				_log("E"&$e&". Error removing symbolic link", $function_name, true)
				$e+=1
				MsgBox(48, "Error", "Error Changing Profile [SymLink Removal Error]")
				Return False

			Else
				_log("N"&$n&". MC Dir is not a Symbolic Link", $function_name)
					$n+=1
			EndIf

				If $selected_profile == "Default" Then

				_log("N"&$n&". Selected profile is Default", $function_name)
					$n+=1
				; Check to see if com.mojang.default folder exists
				If FileExists($working_dir & ".default") Then
					_log("N"&$n&". com.mojang.default directory exists", $function_name)
					$n+=1
					; Rename com.mojang.default to com.mojang
					If DirMove($working_dir & ".default", $working_dir, 0) < 1 Then
					; Error renaming com.mojang.default to com.mojang
					_log("E"&$e&". Error renaming com.mojang.default to com.mojang", $function_name, true)
					$e+=1
					MsgBox(48, "Error", "Error Changing to Default Profile [Rename Error]")
					Return False
					Else
					; Profile Succesfully switched
					_log("N"&$n&". com.mojang.default directory exists", $function_name)
					$n+=1
					Return True
					EndIf

				Else

					; com.mojang.default file does not exist!
					; If com.mojang.default does not exist and we're switching back to the default profile then something is not right!
					; Perhaps the user deleted files from the mc directory or maybe they uninstalled minecraft from the store or used another tool?!?
					; Either way, not much we can do! Return ok but warn.
					_log("E"&$e&". If com.mojang.default does not exist and we're switching back to the default profile then something is not right!", $function_name, true)
					$e+=1
					MsgBox(48, "Something is wrong!", "The default com.mojang folder is missing!" & @CRLF & "The game will reset to default.")
					Return True

				EndIf

			Else

				; Selected profile is not default -> create new symlink
				Local $create_link = _createSymLink($working_dir, $selected_profile_dir, 1)
				If @error > 0 Then
					_log("E"&$e&". Error creating symbolic link!", $function_name)
					$e+=1
					MsgBox(48, "Error", "Error Changing to " & $selected_profile & " profile. [SymLink Creation Error]")
					Return False
				Else
					; Everything went ok
					_log("N"&$n&". Succesfully switched to " & $selected_profile & " profile", $function_name)
					$n+=1
					Return True
				EndIf

			EndIf

		EndIf

	Else

		; Current com.mojang folder is not symlink so rename to com.mojang.default and create symlink
		If $selected_profile == "Default" Then

			_log("N" &$n& ". Default Profile Selected", $function_name)
			$n+=1
			; Do nothing... Default is already active
			Return True

		Else

			_log("N" &$n& ". Default Profile Not Selected", $function_name)
				$n+=1

			; If the selected profile is not default then rename and create symlink
			If DirMove($working_dir, $working_dir & ".default", 0) < 1 Then
				; Error renaming com.mojang to com.mojang.default
				_log("E"&$e&". Error renaming com.mojang to com.mojang.default", $function_name, true)
				$e+=1
				MsgBox(48, "Error", "Error Changing from Default Profile [Rename Error]")
				Return False
			Else

				_log("N"&$n&". Renamed com.mojang to com.mojang.default", $function_name)
				$n+=1

				; Selected profile is not default -> create new symlink
				Local $create_link = _createSymLink($working_dir, $selected_profile_dir, 1)
				If @error > 0 Then
				_log("E"&$e&". Error creating symbolic link", $function_name, true)
				MsgBox(48, "Error", "Error Changing to " & $selected_profile & " profile. [SymLink Creation Error]")
				$e+=1
				Return False
				Else

				_log("N"&$n&". Succesfuly created Symlink", $function_name)
				$n+=1
				; Successfully switched profiles
				Return True

				EndIf

			EndIf

		EndIf

	EndIf

EndFunc