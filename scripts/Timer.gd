extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var time = 48 - (Global.time / 30.0)
	if time <= 0:
		print("DEADEADAWDADWDAW")
	self.text = "Time to destination\n- " + str(floor(time)) + " hours -"
