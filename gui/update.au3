; UPDATE GUI VARS
$inner_width = 200
$inner_height = 100
$margin = 10

$width = $inner_width + ($margin*3)
$height = $inner_height + ($margin*3)

$top = $margin
$left = $margin
$bottom = $top + $inner_height
$right = $left + $inner_width

$col = $inner_width/2
$row = 20

$hGUI_update = GUICreate("Update", $width, $height, -1, -1,$WS_POPUP+$WS_THICKFRAME)
GUISetOnEvent ($GUI_EVENT_CLOSE, "_guiUpdateClose" )
GUISetIcon ("icon.ico")
GUISetFont(12,-1, "Arial")


$hTop = $top
$hLeft = $left

$update_version_hidden_label = GUICtrlCreateLabel("", 0, 0, 1, 1)
GUICtrlSetFont($update_version_hidden_label, 1)

GUICtrlCreateLabel("An update is available", $hLeft, $hTop, $inner_width, $row)

$hTop = $hTop + $row

$update_version_label = GUICtrlCreateLabel($app_version, $hLeft, $hTop, $inner_width, $row)
GUICtrlSetFont($update_version_label, 10)

$hTop = $hTop + $row

$update_download_button = GUICtrlCreateButton("Download", $hLeft, $hTop, $col, $row+$margin)
GUICtrlSetOnEvent($update_download_button, "_guiUpdateDownload")
GUICtrlSetFont($update_download_button, 10)

$hLeft = $hLeft + $col + $margin

$update_close_button = GUICtrlCreateButton("Close", $hLeft, $hTop, $col, $row+$margin)
GUICtrlSetOnEvent($update_close_button, "_guiUpdateClose")
GUICtrlSetFont($update_close_button, 10)

$hTop = $hTop + $row + $row
$hLeft = $left

GUICtrlCreateLabel("Click download, unzip and replace files in the " & $app_name & " directory.", $hLeft, $hTop, $inner_width, $row + $row)
GUICtrlSetFont(-1, 8)

GUISetState(@SW_HIDE)

Func _guiUpdateDownload()

   Local $version = GUICtrlRead($update_version_hidden_label)
   Local $dl_link = $app_dl & $app_name & "-" & $version & ".zip"
   ShellExecute($dl_link)

EndFunc

Func _guiUpdateClose()
   GUISetState(@SW_ENABLE, $hGUI)
   GUISetState(@SW_HIDE, $hGUI_update)
EndFunc

Func OnAutoItExit()
   _guiExit()
EndFunc