extends Label

func _process(delta):
	var time = 48 - (Global.time / 8.0)
	if time <= 0:
		get_tree().change_scene_to_file("res://scenes/lose.tscn")
	self.text = "Time to destination\n- " + str(floor(time)) + " hours -"
