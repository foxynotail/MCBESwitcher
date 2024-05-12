Func _log($string, $function_name, $error=False, $important=False)

   Local $log_data = "[" & $app_title & "] > [" & $function_name & "] > "

   If $error == True OR $important == True OR ($important == False AND $verbose_logging == True) Then

	  _FileWriteLog($log, $log_data & $string) ; log

   EndIf
   If $error == True Then
	  _FileWriteLog($error_log, $log_data & $string) ; log
   EndIf

EndFunc