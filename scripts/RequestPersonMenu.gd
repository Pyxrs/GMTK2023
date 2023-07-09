extends Panel

const DESTS = [
	Vector3(0, -1.991, 0.587),
	Vector3(10.563, -1.991, 8.585),
	Vector3(-13.791, -1.991, 9.073),
	Vector3(-10.719, -1.991, 19.911),
	Vector3(4.927, -1.991, 29.41),
]

# Called when the node enters the scene tree for the first time.
func _ready():
	$OptionButton.add_item("Astrid (Botanist)")
	$OptionButton.add_item("Julianna (Botanist)")
	$OptionButton.add_item("Cyrus (Janitor)")
	$OptionButton.add_item("Tianna (Doctor)")
	$OptionButton.add_item("Darrel (Fisherman)")
	$OptionButton.add_item("Janet (Lunch Lady)")
	$OptionButton.add_item("Doreen (Mechanic)")
	$OptionButton.add_item("Gideon (Mechanic)")
	$OptionButton.add_item("Christi (Nurse)")
	$OptionButton.add_item("Ross (Nurse)")
	$OptionButton.add_item("Aaron (Pilot)")
	$OptionButton.add_item("Eddy (Resident)")
	$OptionButton.add_item("Madlyn (Resident)")
	$OptionButton.add_item("Zoldur (Resident)")
	$OptionButton.add_item("Xavier (Resident)")
	
	$OptionButton2.add_item("Control Room")
	$OptionButton2.add_item("Oxygen Room")
	$OptionButton2.add_item("Water Reservoir")
	$OptionButton2.add_item("Pond Room")
	$OptionButton2.add_item("Greenhouse")

func _on_button_pressed():
	var guy = Global.get_person($OptionButton.selected, get_parent().get_parent().get_node("Crewmates"))
	var dest = DESTS[$OptionButton2.selected]
	
	if guy and guy.paranoia < 0.6:
		guy.distracted = 25
		guy.pathfind_to(dest)
		$Button.disabled = true
		$Timer.start()


func _on_request_person_pressed():
	show()


func _on_timer_timeout():
	$Button.disabled = false
