Func _randomString($num)

    $string = ""
    For $i = 0 To $num 
        $string = $string & Chr(Random(Asc("A"), Asc("Z"), 1))
    Next

    return $string

EndFunc