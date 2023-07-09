extends Node3D

@export var sprite: Texture2D

func _ready():
	$Sprite3D.texture = sprite
	position.y += (randf() / 100.0)
	rotation.y = deg_to_rad(randf_range(0, 360))

func _on_timer_timeout():
	for guy in get_parent().get_children():
		if guy.has_method("die") and position.distance_squared_to(guy.position) < 10.0:
			guy.paranoia += 0.1
			if guy.person == 1 and !guy.cleaned:
				guy.pathfind_to(position)
				guy.cleaned = true
				queue_free()
