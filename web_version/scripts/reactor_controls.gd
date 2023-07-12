extends Panel

func _on_button_pressed():
	var people = get_parent().get_parent().get_node("Crewmates").get_children()
	for p in people:
		p.paranoia += 0.1
		if p.person == 5 and p.paranoia < 0.6:
			p.distracted = 30
			p.pathfind_to(Vector3(-1.689, -1.995, 8.999))
			$Button.disabled = true
			$Timer.start()

func _on_reactor_controls_pressed():
	show()

func _on_timer_timeout():
	$Button.disabled = false
