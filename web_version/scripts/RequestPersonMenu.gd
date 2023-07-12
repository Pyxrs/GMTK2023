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
	$OptionButton.clear()
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
	
	if !get_parent().get_parent().get_node("Crewmates").get_node_or_null("Crewmate15"):
		$OptionButton.remove_item(14)
	if !get_parent().get_parent().get_node("Crewmates").get_node_or_null("Crewmate14"):
		$OptionButton.remove_item(13)
	if !get_parent().get_parent().get_node("Crewmates").get_node_or_null("Crewmate13"):
		$OptionButton.remove_item(12)
	if !get_parent().get_parent().get_node("Crewmates").get_node_or_null("Crewmate12"):
		$OptionButton.remove_item(11)
	if !get_parent().get_parent().get_node("Crewmates").get_node_or_null("Crewmate11"):
		$OptionButton.remove_item(10)
	if !get_parent().get_parent().get_node("Crewmates").get_node_or_null("Crewmate10"):
		$OptionButton.remove_item(9)
	if !get_parent().get_parent().get_node("Crewmates").get_node_or_null("Crewmate9"):
		$OptionButton.remove_item(8)
	if !get_parent().get_parent().get_node("Crewmates").get_node_or_null("Crewmate8"):
		$OptionButton.remove_item(7)
	if !get_parent().get_parent().get_node("Crewmates").get_node_or_null("Crewmate7"):
		$OptionButton.remove_item(6)
	if !get_parent().get_parent().get_node("Crewmates").get_node_or_null("Crewmate6"):
		$OptionButton.remove_item(5)
	if !get_parent().get_parent().get_node("Crewmates").get_node_or_null("Crewmate5"):
		$OptionButton.remove_item(4)
	if !get_parent().get_parent().get_node("Crewmates").get_node_or_null("Crewmate4"):
		$OptionButton.remove_item(3)
	if !get_parent().get_parent().get_node("Crewmates").get_node_or_null("Crewmate3"):
		$OptionButton.remove_item(2)
	if !get_parent().get_parent().get_node("Crewmates").get_node_or_null("Crewmate2"):
		$OptionButton.remove_item(1)
	if !get_parent().get_parent().get_node("Crewmates").get_node_or_null("Crewmate1"):
		$OptionButton.remove_item(0)
	
	show()

func _on_timer_timeout():
	$Button.disabled = false
