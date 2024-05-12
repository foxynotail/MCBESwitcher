Func _switchVersion($type, $selected_version)

   Local $function_name = "Switch Version"
   Local $n = 0, $e = 0

   Local $selected_version_dir = $version_dir & "\" & $selected_version


   ;MsgBox(0, "", "Switch Version " & $selected_version_dir)

   ; Close Minecraft First
   If ProcessExists('Minecraft.Windows.exe') Then
		Local $confirm = MsgBox(4, "Launching Minecraft", "Minecraft must be closed to continue." & @CRLF & @CRLF & "This app will close down any versions of Minecraft and Minecraft Preview automatically when you click Yes." & @CRLF & @CRLF & "Are you happy to coninue?")
		If $confirm > 6 Then
			Return True
		EndIf
   	EndIf
	Do
		ProcessClose('Minecraft.Windows.exe')
	Until Not ProcessExists('Minecraft.Windows.exe')

	; Check if this minecraft version is installed on the system
	local $dev_version = checkVersionInstalled($selected_version)
	If NOT ($dev_version = 0) Then
		downloadVersion($dev_version)
	EndIf

   ; # Switch Versions;
   ; Don't need to delete files as using -ForceUpdateFromAnyVersion
   ; Add-AppxPackage -Path C:\Users\foxynotail\Desktop\MC1.14.60\MultiLaunch\MCLauncher\Minecraft-1.14.20.1\AppxManifest.xml -Register -ForceApplicationShutdown -ForceUpdateFromAnyVersion -RetainFilesOnFailure

   Local $manifest_path = $selected_version_dir & "\AppxManifest.xml"
   If FileExists($manifest_path) Then

	  Local $powershell_command = "Add-AppxPackage -Path '" & $manifest_path & "' -Register -ForceApplicationShutdown -ForceUpdateFromAnyVersion"
	  Local $iReturn = RunWait($powershell_path & " -Command " & $powershell_command, @WindowsDir, @SW_HIDE)
	  If @error > 0 Then

		 ; Error Running Powershell Command
		 _log("E"&$e&". Error Running Powershell Command", $function_name, true)
		 $e+=1
		 MsgBox(48, "Error", "Error Launching Minecraft.")
		 Return False

	  Else

		 ; Successful Running Powershell Command
		 _log("N"&$n&". Powershell Command Ran Succesfully", $function_name)
		 $n+=1

		 ; If newly installed Minecraft need to create games\com.mojang folder inside of LocalState folder so we can switch profiles on 1st launch
		 If $type == 'minecraft' Then
		 	Local $package_dir = $mc_package_dir
			Local $user_account = $mc_user
		Else
			Local $package_dir = $preview_package_dir
			Local $user_account = $preview_user
		EndIf	
		Local $com_folder = $package_dir & "\games\com.mojang"
		Local $games_folder = $package_dir & "\games"
		
		If FileExists($package_dir) Then
		 	If NOT FileExists($games_folder) Then
		 		; Create folder & give permissions
				DirCreate($games_folder)
				Local $perms_command = 'icacls "' & $games_folder & '" /grant *' & $user_account & ':(OI)(CI)F'
				RunWait(@ComSpec & " /c " & $perms_command, "", @SW_HIDE)
			EndIf
		 	If NOT FileExists($com_folder) Then
		 		; Create folder & give permissions
				DirCreate($com_folder)
				Local $perms_command = 'icacls "' & $com_folder & '" /grant *' & $user_account & ':(OI)(CI)F'
				RunWait(@ComSpec & " /c " & $perms_command, "", @SW_HIDE)
			EndIf
		EndIf

		Return True

	  EndIf


   Else

	  ; Error Version Manifest File Doesn't Exist
	  _log("E"&$e&". AppxManifest.xml file not found", $function_name, true)
	  $e+=1
	  MsgBox(48, "Error", "Required files not found.")
	  Return False

   EndIf

   Return False

EndFunc