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

var velocity = Vector3.ZERO

# Stats
var satiation = randf()
var energy = randf()
var social = randf()
var work = randf()
var shittiness = randf()
var paranoia = 0.0

var action = Actions.WORK

func _ready():
	$Sprite3D.texture = sprite
	
	# Set up pathfinding
	navigation_agent.path_desired_distance = 0.5
	navigation_agent.target_desired_distance = 0.5
	call_deferred("nav_setup")

func _process(delta):
	pass
	# Walking animation
	$Sprite3D.position.x = cos(Global.time * BOUNCE_SPEED) * BOUNCE_SCALE * velocity.length()
	$Sprite3D.position.y = (cos(Global.time * BOUNCE_SPEED * 2) + 1) * BOUNCE_SCALE * velocity.length() + 0.75

func _physics_process(delta):
	if navigation_agent.is_navigation_finished():
		velocity /= 1.05
		return

	velocity = (navigation_agent.get_next_path_position() - global_position).normalized() * 0.05
	position += velocity

func _on_action_tick_timeout():
	$ActionTick.wait_time = randf_range(10, 20)
	stop_action()
	tick_status()
	
	action = decide_action()
	start_action()

func _on_idle_tick_timeout():
	print("cheese")
	if action == Actions.WORK and (navigation_agent.is_navigation_finished() or !navigation_agent.is_target_reachable()):
		$IdleTick.wait_time = randf() * 5
		pathfind_to(Vector3(position.x + randf_range(-2, 2), position.y, position.z + randf_range(-2, 2)))

func nav_setup():
	# Wait for the first physics frame to sync
	await get_tree().physics_frame
	_on_action_tick_timeout()

func pathfind_to(movement_target: Vector3):
	navigation_agent.set_target_position(movement_target)

func tick_status():
	satiation -= 0.1
	energy -= 0.05
	social -= 0.1
	work -= 0.2
	shittiness += 0.05
	
	satiation = clamp(satiation, 0, 1)
	energy = clamp(energy, 0, 1)
	social = clamp(social, 0, 1)
	work = clamp(work, 0, 1)
	shittiness = clamp(shittiness, 0, 1)

func decide_action():
	var options = [
		[Actions.EAT, (1 - self.satiation) / 1.1],
		[Actions.SLEEP, (1 - self.energy)],
		[Actions.TALK, (1 - self.social) / 2.0],
		[Actions.WORK, (1 - self.work) / 1.5],
		[Actions.SHIT, (self.shittiness) / 1.2],
		[Actions.PANIC, (self.paranoia)],
		[Actions.WORSHIP, (self.paranoia / 1.5) + ((1 - self.energy) / 1.5)],
	]
	options.sort_custom(sort_weights)
	var chance = randf()
	if chance < 0.85:
		return options[0][0]
	else:
		return options[1][0]

func start_action():
	if action == Actions.EAT:
		pathfind_to(Vector3(8.716, -2.055, 20.688))
	elif action == Actions.SLEEP:
		pathfind_to(Vector3(-1.164, -2.055, 35.093))
	elif action == Actions.TALK:
		var target = get_parent().get_child(randi_range(0, 14))
		pathfind_to(target.position)
	elif action == Actions.WORK:
		pathfind_to(work_positions.get_child(person).position)
	elif action == Actions.SHIT:
		pathfind_to(Vector3(-11.239, -2.055, 34.802))

func stop_action():
	if action == Actions.EAT:
		satiation += 1.0
	elif action == Actions.SLEEP:
		energy += 1.0
	elif action == Actions.TALK:
		social += 1.0
	elif action == Actions.WORK:
		energy += 1.0
	elif action == Actions.SHIT:
		shittiness -= 1.0

func sort_weights(a, b):
	return a[1] > b[1]

# Thoughts
func _on_navigation_agent_3d_navigation_finished():
	if randf() < 1.0:
		$ThoughtTimer.start()
		$AnimatedSprite3D.show()
		if action == Actions.EAT:
			$AnimatedSprite3D.frame = 0
		elif action == Actions.SLEEP:
			$AnimatedSprite3D.frame = 1
		elif action == Actions.TALK:
			$AnimatedSprite3D.frame = 2
		elif action == Actions.WORK:
			if randf() < 0.3:
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
