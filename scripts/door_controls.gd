extends Panel

func _ready():
	$OptionButton2.add_item("Control Room")
	$OptionButton2.add_item("Oxygen Room")
	$OptionButton2.add_item("Water Reservoir")
	$OptionButton2.add_item("Pond Room")
	$OptionButton2.add_item("Greenhouse")
	$OptionButton2.add_item("Bunks")

func _on_button_pressed():
	var rooms = get_parent().get_parent().rooms
	rooms[rooms.keys()[$OptionButton2.selected]].closed = 20
	$Button.disabled = true
	$Timer.start()

func _on_timer_timeout():
	$Button.disabled = false

func _on_door_controls_pressed():
	show()
