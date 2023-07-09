extends Label

func _process(delta):
	var time = 48 - (Global.time / 10.0)
	if time <= 0:
		print("DEADEADAWDADWDAW")
	self.text = "Time to destination\n- " + str(floor(time)) + " hours -"
