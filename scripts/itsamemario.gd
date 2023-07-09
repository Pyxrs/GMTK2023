extends Sprite3D

var go = false
var end = false
var kill_count = 0

func _process(delta):
	if get_parent().get_parent().rooms.plants.oxygen > 0 and !end:
		go = true
		show()
	
	if go:
		for c in get_parent().get_parent().get_node("Crewmates").get_children():
			if global_position.distance_squared_to(c.global_position) < 12 and c.has_method("die"):
				c.die()
				kill_count += 1
				if kill_count >= 2:
					go = false
					end = true
					hide()
