
Local $profile_label = GUICtrlCreateLabel("PROFILE:", $left+$margin, 98, 400, 20)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
GUICtrlSetFont(-1, 16, $FW_BOLD)
GUICtrlSetColor(-1, 0xFFFFFF)

Local $profile_box = GUICtrlCreateCombo("", $left+$margin, 128, 400, $row-4)
GUICtrlSetFont(-1, 18, $FW_BOLD)
GUICtrlSetBkColor(-1, 0x333333)
GUICtrlSetColor(-1, 0xE9E9E9)

; Add additional items to the combobox.
Local $profiles = _getProfiles()
Local $profile_string = "Default|"
If UBound($profiles) > 1 Then

   For $i=1 To UBound($profiles)-1

      $profile_string &= $profiles[$i] & "|"

   Next

   $profile_string = StringLeft($profile_string, StringLen($profile_string)-1) ; Remove trailing |

EndIf

Local $set_profile = $current_profile

If $set_profile == "" Then
   $set_profile = "Default"
EndIf

; Check current profile from symlink

GUICtrlSetData($profile_box, $profile_string, $set_profile)

Local $text_label = "Choose which profile to run. Profiles are the folders containing your worlds, packs and settings."
Local $profile_label = GUICtrlCreateLabel($text_label, $right-$margin-400, 100, 400, 50, $SS_RIGHT)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
GUICtrlSetFont($profile_label, 12, $FW_NORMAL)
GUICtrlSetColor(-1, 0xFFFFFF)