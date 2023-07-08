extends Node

var zoom = 3.333333
var velocity = Vector2.ZERO

func _input(event):
	if $GeneratorCam.current:
		if Input.is_action_pressed("pan"):
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			if event is InputEventMouseMotion:
				velocity -= event.relative / 15000
		else:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		zoom -= Input.get_axis("zoom_in", "zoom_out") * 5

func _process(delta):
	if $GeneratorCam.current:
		zoom = clamp(zoom, 0, 75)
		$GeneratorCam.fov = move_toward($GeneratorCam.fov, 1000 / (zoom + 10), delta * 75)
		$GeneratorCam.rotation.y += velocity.x
		$GeneratorCam.rotation.x += velocity.y
		velocity /= 1.02
		$GeneratorCam.rotation.y = clamp($GeneratorCam.rotation.y, -2.7, 0.7)

func _on_button_pressed():
	$ControlCam.make_current()

func _on_button_2_pressed():
	$WaterCam.make_current()

func _on_button_3_pressed():
	$GeneratorCam.make_current()

func _on_button_4_pressed():
	$OxygenCam.make_current()

func _on_button_5_pressed():
	$KitchenCam.make_current()

func _on_button_6_pressed():
	$MainCam.make_current()

func _on_button_7_pressed():
	$PondCam.make_current()

func _on_button_8_pressed():
	$ShitterCam.make_current()

func _on_button_9_pressed():
	$BedCam.make_current()

func _on_button_10_pressed():
	$PlantCam.make_current()
