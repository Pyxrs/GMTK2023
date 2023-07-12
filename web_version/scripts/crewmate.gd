extends Node3D

const BOUNCE_SCALE = 2
const BOUNCE_SPEED = 8

enum Person {
	BOTANIST,
	JANITOR,
	DOCTOR,
	FISHERMAN,
	LUNCH_LADY,
	MECHANIC,
	NURSE,
	PILOT,
	RESIDENT,
	SHITTER,
	NERD, # Not yet made
}

enum Actions {
	EAT,
	SLEEP,
	TALK,
	WORK,
	SHIT,
	PANIC,
	WORSHIP,
}

@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D
@onready var work_positions = get_parent().get_parent().get_node("WorkPositions")

@export var person: Person
@export var sprite: Texture2D
@export var work_ethic = 1.0
@export var eye_height = 15

var paranoid_sprite1 = preload("res://Crew sprites/Parranoyed overlay.png")
var paranoid_sprite2 = preload("res://Crew sprites/Parranoyed overlay2.png")
var possessed_sprite = preload("res://Crew sprites/Poseesed overlay.png")
var sick_sprite = preload("res://Crew sprites/Sick Overlay.png")

var dead_scene = preload("res://scenes/dead.tscn")

var velocity = Vector3.ZERO
var speed = (randf_range(0, 0.75) + 0.5) * (work_ethic / 2 + 0.5)
var cultist = false
var sick = false

# Stats
var satiation = randf()
var energy = randf()
var social = randf()
var work = randf()
var shittiness = randf()
var paranoia = 0.0

var pathfinding_valid = true

var action = Actions.WORK
var distracted = 0

func _ready():
	var eye_pos = -0.9 + (eye_height * (0.7 / 15.0))
	$Sprite3D/Overlay.position.y = eye_pos
	$Sprite3D/Overlay2.position.y = eye_pos
	$Sprite3D/Overlay3.position.y = eye_pos
	$Sprite3D/Overlay4.position.y = eye_pos
	
	$ActionTick.wait_time = randf_range(10, 20) * (1 / speed)
	$ActionTick.start()
	$IdleTick.wait_time = randf() * 5 * (1 / speed)
	$IdleTick.start()
	
	$Sprite3D.texture = sprite
	
	# Set up pathfinding
	navigation_agent.path_desired_distance = 0.5
	navigation_agent.target_desired_distance = 0.5
	call_deferred("nav_setup")

func _process(delta):
	if distracted > 0:
		distracted -= delta
	
	$PathfindingPoint.global_position = $NavigationAgent3D.get_final_position()
	
	# Walking animation
	var less_varying_speed = (speed / 2) + 0.5
	$Sprite3D.position.x = cos(Global.time * BOUNCE_SPEED * less_varying_speed) * BOUNCE_SCALE * velocity.length()
	$Sprite3D.position.y = (cos(Global.time * BOUNCE_SPEED * less_varying_speed * 2) + 1) * BOUNCE_SCALE * velocity.length() + 0.75
	if velocity.length() > 0.02 and -sin(Global.time * BOUNCE_SPEED * less_varying_speed * 2) > 0.9 and !$Jump.playing:
		$Jump.pitch_scale = randf_range(0.8, 1.2)
		$Jump.play()

func _physics_process(delta):
	if navigation_agent.is_navigation_finished():
		velocity /= 1.05
		return

	if pathfinding_valid:
		velocity = (navigation_agent.get_next_path_position() - global_position).normalized() * 0.05 * speed
		position += velocity
	else:
		velocity = velocity.move_toward(Vector3.ZERO, delta * 10)

func _on_action_tick_timeout():
	$ActionTick.wait_time = randf_range(10, 20) * (1 / speed)
	stop_action()
	tick_status()
	
	if distracted <= 0:
		action = decide_action()
		start_action()

func _on_idle_tick_timeout():
	update_overlay()
	pathfinding_valid = true
	for a in $PathfindingPoint.get_overlapping_areas():
		if a.has_method("unique") and get_parent().get_parent().rooms[a.id].closed > 0:
			pathfinding_valid = false
	
	if action == Actions.WORK and (navigation_agent.is_navigation_finished() or !navigation_agent.is_target_reachable()):
		$IdleTick.wait_time = randf() * 5 * (1 / speed)
		pathfind_to(Vector3(position.x + randf_range(-2, 2), position.y, position.z + randf_range(-2, 2)))
	if action == Actions.PANIC:
		$IdleTick.wait_time = randf_range(0.2, 0.5)
		pathfind_to(Vector3(position.x + randf_range(-10, 10), position.y, position.z + randf_range(-10, 10)))

func die():
	var corpse = dead_scene.instantiate()
	corpse.position = position
	corpse.sprite = $Sprite3D.texture
	get_parent().add_child(corpse)
	queue_free()

func nav_setup():
	# Wait for the first physics frame to sync
	await get_tree().physics_frame
	_on_action_tick_timeout()

func pathfind_to(movement_target: Vector3):
	for a in $Area3D.get_overlapping_areas():
		if a.has_method("unique") and get_parent().get_parent().rooms[a.id].closed > 0:
			return
	
	navigation_agent.set_target_position(movement_target)

func tick_status():
	satiation -= 0.1
	energy -= 0.05
	social -= 0.1
	work -= 0.2 * work_ethic
	shittiness += 0.05
	paranoia -= 0.15
	
	satiation = clamp(satiation, 0, 1)
	energy = clamp(energy, 0, 1)
	social = clamp(social, 0, 1)
	work = clamp(work, 0, 1)
	shittiness = clamp(shittiness, 0, 1)
	paranoia = clamp(paranoia, 0, 2)

func decide_action():
	var options = [
		[Actions.EAT, (1 - self.satiation) / 1.1],
		[Actions.SLEEP, (1 - self.energy)],
		[Actions.TALK, (1 - self.social) / 2.0],
		[Actions.WORK, (1 - self.work) * work_ethic / 1.5],
		[Actions.SHIT, (self.shittiness) / 1.2],
		[Actions.PANIC, (self.paranoia)],
		[Actions.WORSHIP, (self.paranoia / 2.0) + ((1 - self.energy) / 3.0)],
	]
	if person == Person.SHITTER:
		options[1][1] -= 0.5
	if cultist:
		options[0][1] -= 0.5
		options[1][1] -= 0.5
		options[2][1] -= 0.5
		options[3][1] -= 0.5
		options[4][1] -= 0.5
		options[5][1] -= 0.5
	
	options.sort_custom(sort_weights)
	var chance = randf()
	if chance < 0.85:
		return options[0][0]
	else:
		return options[1][0]

func update_overlay():
	if sick:
		set_overlays(true, sick_sprite)
	elif cultist:
		set_overlays(true, possessed_sprite)
	elif paranoia > 0.75:
		if int(floor(Global.time)) % 2 == 0:
			set_overlays(true, paranoid_sprite1)
		else:
			set_overlays(true, paranoid_sprite2)
	else:
		set_overlays(false, null)

func set_overlays(show, texture: Texture2D):
	if show:
		$Sprite3D/Overlay.show()
		$Sprite3D/Overlay2.show()
		$Sprite3D/Overlay3.show()
		$Sprite3D/Overlay4.show()
	else:
		$Sprite3D/Overlay.hide()
		$Sprite3D/Overlay2.hide()
		$Sprite3D/Overlay3.hide()
		$Sprite3D/Overlay4.hide()
	if texture:
		$Sprite3D/Overlay.texture = texture
		$Sprite3D/Overlay2.texture = texture
		$Sprite3D/Overlay3.texture = texture
		$Sprite3D/Overlay4.texture = texture

func start_action():
	if sick and randf() < 0.1:
		if randf() > 0.3:
			var guy = get_parent().get_child(get_parent().get_children().size() - 1)
			if guy.has_method("die"):
				guy.sick = true
		else:
			die()
	
	if action == Actions.EAT:
		pathfind_to(Vector3(8.716, -2.055, 20.688 + randf_range(-3, 3)))
	elif action == Actions.SLEEP:
		pathfind_to(Vector3(-3.627 + randf_range(-1.5, 1.5), -1.861, 28.72))
	elif action == Actions.TALK:
		var target
		var found = false
		for i in range(20):
			target = get_parent().get_child(randi_range(0, get_parent().get_children().size() - 1))
			if target.has_method("die"):
				found = true
				break
		if found:
			pathfind_to(target.position)
	elif action == Actions.WORK:
		pathfind_to(work_positions.get_child(person).position)
	elif action == Actions.SHIT:
		pathfind_to(Vector3(-11.239 - randf_range(0, 3), -2.055, 34.802))
	elif action == Actions.WORSHIP:
		pathfind_to(Vector3(1.936, -2.211, 23.755))
		if randf() < 0.75:
			cultist = true

func stop_action():
	if action == Actions.EAT:
		satiation += 1.0
	elif action == Actions.SLEEP:
		if person != Person.SHITTER:
			energy += 1.0
		else:
			energy += 0.5
	elif action == Actions.TALK:
		social += 1.0
	elif action == Actions.WORK:
		work += 1.0
	elif action == Actions.SHIT:
		shittiness -= 1.0
	elif action == Actions.WORSHIP:
		_on_navigation_agent_3d_navigation_finished()
		if !Global.worship_totem:
			get_parent().get_parent().get_node("WorshipTotem").show()
		if cultist:
			for c in get_parent().get_children():
				if c.has_method("die") and global_position.distance_squared_to(c.global_position) < 20:
					if randf() < 0.01:
						c.cultist = true
					elif randf() < 0.03:
						c.die()
					elif randf() < 0.1:
						paranoia += 0.015

func sort_weights(a, b):
	return a[1] > b[1]

# Thoughts
func _on_navigation_agent_3d_navigation_finished():
	$ThoughtTimer.start()
	$AnimatedSprite3D.show()
	if action == Actions.EAT:
		$AnimatedSprite3D.frame = 0
	elif action == Actions.SLEEP:
		$AnimatedSprite3D.frame = 1
	elif action == Actions.TALK:
		$AnimatedSprite3D.frame = 2
	elif action == Actions.WORK:
		if randf() < 0.05:
			$AnimatedSprite3D.frame = 7
		else:
			$ThoughtTimer.stop()
			$AnimatedSprite3D.hide()
	elif action == Actions.SHIT:
		$AnimatedSprite3D.frame = 3
	elif action == Actions.PANIC:
		$AnimatedSprite3D.frame = 4
	elif action == Actions.WORSHIP:
		$AnimatedSprite3D.frame = 5

# Thoughts
func _on_thought_timer_timeout():
	$AnimatedSprite3D.hide()
