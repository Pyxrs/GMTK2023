extends Panel

func _on_button_pressed():
	var people = get_parent().get_parent().get_node("Crewmates").get_children()
	for p in people:
		if p.has_method("die") and Vector3(-12.56, -1.995, 33.619).distance_squared_to(p.global_position) < 4.5 and randf() < 0.25:
			p.sick = true
	$Button.disabled = true

func _on_plumbing_pressed():
	show()
