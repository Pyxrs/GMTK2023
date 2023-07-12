extends Node

@onready var ui = get_parent().get_node("UI")

var zoom = 3.333333
var velocity = Vector2.ZERO

func _ready():
	_on_button_pressed()

func _input(event):
	if Input.is_action_pressed("pan"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		if event is InputEventMouseMotion:
			velocity -= event.relative / 15000
	else:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	zoom -= Input.get_axis("zoom_in", "zoom_out") * 5

func _process(delta):
	var cam = get_viewport().get_camera_3d()
	zoom = clamp(zoom, 0, 75)
	cam.fov = move_toward(cam.fov, 1000 / (zoom + 10), delta * 75)
	cam.rotation.y += velocity.x
	cam.rotation.x += velocity.y
	velocity /= 1.02
	
	ui.get_node("TextureRect2").rotation = -cam.rotation.y
	
	if $GeneratorCam.current:
		$GeneratorCam.rotation.y = clamp($GeneratorCam.rotation.y, -2.7, 0.7)

func _on_button_pressed():
	set_cam(ui.get_node("Button"), $ControlCam)

func _on_button_2_pressed():
	set_cam(ui.get_node("Button2"), $WaterCam)

func _on_button_3_pressed():
	set_cam(ui.get_node("Button3"), $GeneratorCam)

func _on_button_4_pressed():
	set_cam(ui.get_node("Button4"), $OxygenCam)

func _on_button_5_pressed():
	set_cam(ui.get_node("Button5"), $KitchenCam)

func _on_button_6_pressed():
	set_cam(ui.get_node("Button6"), $MainCam)

func _on_button_7_pressed():
	set_cam(ui.get_node("Button7"), $PondCam)

func _on_button_8_pressed():
	set_cam(ui.get_node("Button8"), $ShitterCam)

func _on_button_9_pressed():
	set_cam(ui.get_node("Button9"), $BedCam)

func _on_button_10_pressed():
	set_cam(ui.get_node("Button10"), $PlantCam)

func set_cam(button, cam):
	ui.get_node("TextureRect2").position = button.position - Vector2(714.5, 714.5)
	cam.make_current()
	zoom = 3.333333
	velocity = Vector2.ZERO
