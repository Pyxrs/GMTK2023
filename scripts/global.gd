extends Node

var time = 0

func _ready():
	randomize()

func _process(delta):
	time += delta
