
Local $mc_version_label = GUICtrlCreateLabel("MINECRAFT STABLE RELEASE:", $left+$margin, 318, 400, 20)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
GUICtrlSetFont(-1, 16, $FW_BOLD)
GUICtrlSetColor(-1, 0xFFFFFF)

Local $mc_version_box = GUICtrlCreateCombo("", $left+$margin, 348, 500, $row-4)
GUICtrlSetFont(-1, 16, $FW_BOLD)
GUICtrlSetBkColor(-1, 0x333333)
GUICtrlSetColor(-1, 0xE9E9E9)

; Add additional items to the combobox.
;Local $mc_versions = _getVersions('stable')
Local $function_name = 'Load Gui'
Local $e = 0
Local $mc_versions = _getWebVersions('Stable')
Local $mc_version_string
Local $latest_mc_version

If UBound($mc_versions) > 1 Then

   For $i=1 To UBound($mc_versions)-1

	  $mc_version_string &= $mc_versions[$i] & "|"
     $latest_mc_version = $mc_versions[$i]
     ; $latest_mc_version = StringReplace($mc_versions[$i], " [Installed]", "")
     If NOT $current_version = "" Then
         If $current_version = StringReplace($mc_versions[$i], " [Installed]", "") Then
            $current_version = $current_version & " [Installed]"
         EndIf
      EndIf

   Next

   $mc_version_string = StringLeft($mc_version_string, StringLen($mc_version_string)-1) ; Remove trailing |

EndIf

Local $set_version = $current_version

If $set_version == "" Then
   $set_version = $latest_mc_version
EndIf

GUICtrlSetData($mc_version_box, $mc_version_string, $set_version)