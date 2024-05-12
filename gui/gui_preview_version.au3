
Local $preview_version_label = GUICtrlCreateLabel("MINECRAFT PREVIEW:", $left+$margin, 538, 400, 20)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
GUICtrlSetFont(-1, 16, $FW_BOLD)
GUICtrlSetColor(-1, 0xFFFFFF)

Local $preview_version_box = GUICtrlCreateCombo("", $left+$margin, 558, 500, $row-4)
GUICtrlSetFont(-1, 16, $FW_BOLD)
GUICtrlSetBkColor(-1, 0x333333)
GUICtrlSetColor(-1, 0xE9E9E9)

; Add additional items to the combobox.
;Local $preview_versions = _getVersions('preview')
Local $function_name = 'Load Gui'
Local $e = 0
Local $preview_versions = _getWebVersions('Preview')

Local $preview_version_string
Local $latest_preview_version

If UBound($preview_versions) > 1 Then

   For $i=1 To UBound($preview_versions)-1

	  $preview_version_string &= $preview_versions[$i] & "|"
     $latest_preview_version = $preview_versions[$i]
     If NOT $current_preview_version = "" Then
         If $current_preview_version = StringReplace($preview_versions[$i], " [Installed]", "") Then
            $current_preview_version = $current_preview_version & " [Installed]"
         EndIf
      EndIf

   Next

   $preview_version_string = StringLeft($preview_version_string, StringLen($preview_version_string)-1) ; Remove trailing |

EndIf

Local $set_version = $current_preview_version

If $set_version == "" Then
   $set_version = $latest_preview_version
EndIf

GUICtrlSetData($preview_version_box, $preview_version_string, $set_version)