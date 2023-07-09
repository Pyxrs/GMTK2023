extends Node

func _on_timer_timeout():
	if randf() > 0.5:
		$Fart.pitch_scale = randf_range(0.8, 1.2)
		$Fart.play()
