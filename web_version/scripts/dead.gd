extends Node3D

@export var sprite: Texture2D

func _ready():
	$Sprite3D.texture = sprite
	position.y += (randf() / 100.0)
	rotation.y = deg_to_rad(randf_range(0, 360))

func _on_timer_timeout():
	for guy in get_parent().get_children():
		if guy.has_method("die"):
			if position.distance_squared_to(guy.position) < 10.0:
				guy.paranoia += 0.1
				guy.energy += 0.3
			if position.distance_squared_to(guy.position) < 40.0 and guy.person == 1 and guy.distracted < 1:
				guy.distracted = 10
				guy.pathfind_to(position)
			if position.distance_squared_to(guy.position) < 5.0 and guy.person == 1:
				queue_free()

func unique_indeed():
	pass
