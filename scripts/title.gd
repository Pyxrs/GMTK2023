extends Control

var e = preload("res://scenes/world.tscn")

func _on_button_pressed():
	get_tree().change_scene_to_packed(e)
