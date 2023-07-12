extends Node3D

var rooms = {
	"control": {
		"closed": 0,
		"oxygen": 0,
		"doors": [
			"Door",
			"Door2",
		],
	},
	"oxygen": {
		"closed": 0,
		"oxygen": 0,
		"doors": [
			"Door3",
		],
	},
	"water": {
		"closed": 0,
		"oxygen": 0,
		"doors": [
			"Door4",
			"Door5",
		],
	},
	"pond": {
		"closed": 0,
		"oxygen": 0,
		"doors": [
			"Door6",
			"Door7",
		],
	},
	"plants": {
		"closed": 0,
		"oxygen": 0,
		"doors": [
			"Door8",
		],
	},
	"bunks": {
		"closed": 0,
		"oxygen": 0,
		"doors": [
			"Door9",
		],
	}
}

func _on_update_timeout():
	var people_alive = 0
	for c in get_node("Crewmates").get_children():
		if c.has_method("die"):
			people_alive += 1
	
	if people_alive <= 0:
		get_tree().change_scene_to_file("res://scenes/win.tscn")
	
	for room in rooms:
		if rooms[room].closed > 0:
			rooms[room].closed -= 1
		if rooms[room].oxygen > 0:
			rooms[room].oxygen -= 1
	
	for room in rooms:
		for door in rooms[room].doors:
			if rooms[room].closed > 0:
				get_node(door).show()
			else:
				get_node(door).hide()
		
	if rooms.control.oxygen > 0:
		for a in $Areas/Control.get_overlapping_areas():
			if a.name == "Area3D":
				a.get_parent().die()
	
	if rooms.oxygen.oxygen > 0:
		for a in $Areas/Oxygen.get_overlapping_areas():
			if a.name == "Area3D":
				a.get_parent().die()
	
	if rooms.water.oxygen > 0:
		for a in $Areas/Water.get_overlapping_areas():
			if a.name == "Area3D":
				a.get_parent().die()
	
	if rooms.pond.oxygen > 0:
		for a in $Areas/Pond.get_overlapping_areas():
			if a.name == "Area3D":
				a.get_parent().die()
	
	if rooms.plants.oxygen > 0:
		for a in $Areas/Plants.get_overlapping_areas():
			if a.name == "Area3D":
				a.get_parent().die()
	
	if rooms.bunks.oxygen > 0:
		for a in $Areas/Bunks.get_overlapping_areas():
			if a.name == "Area3D":
				a.get_parent().die()
