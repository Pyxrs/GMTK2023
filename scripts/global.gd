extends Node

var time = 0
var worship_totem = false

func _ready():
	randomize()

func _process(delta):
	time += delta
