extends TextureButton

var on = preload("res://Crew sprites/Music_togle_on.png")
var off = preload("res://Crew sprites/Music_togle_off.png")

func _process(delta):
	if Global.music:
		texture_normal = on
	else:
		texture_normal = off

func _on_pressed():
	Global.music = !Global.music
