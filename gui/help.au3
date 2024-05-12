; UPDATE GUI VARS
$inner_width = 400
$inner_height = 600
$margin = 5

$width = $inner_width + ($margin*2)
$height = $inner_height + ($margin*2)

$top = $margin
$left = $margin

$hGUI_help = GUICreate("Help", $width, $height, -1, -1)

GUISetOnEvent ($GUI_EVENT_CLOSE, "_guiHelpClose" )
GUISetIcon ("icon.ico")
GUISetFont(8.5,-1, "Arial")

Local $readme = @ScriptDir & "\readme.txt"
Local $help_text = FileRead($readme)
$help_edit = GUICtrlCreateEdit($help_text, $left, $top, $inner_width, $inner_height, $ES_READONLY + $WS_VSCROLL)
GUICtrlSetState($help_edit, $GUI_FOCUS) ; give focus to the edit ctrl

GUISetState(@SW_HIDE)

Func _guiHelpClose()
   GUISetState(@SW_ENABLE, $hGUI)
   GUISetState(@SW_HIDE, $hGUI_help)
EndFunc