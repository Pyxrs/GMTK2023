extends AudioStreamPlayer

func _process(delta):
	if Global.music and !playing:
		play()
	if !Global.music and playing:
		stop()
