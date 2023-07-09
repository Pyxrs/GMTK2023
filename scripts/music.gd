extends AudioStreamPlayer

func _on_timer_timeout():
	if randf() > 0.5:
		play()
