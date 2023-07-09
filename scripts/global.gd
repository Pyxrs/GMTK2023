extends Node

var music = true
var time = 0
var worship_totem = false

func _ready():
	randomize()

func _process(delta):
	time += delta

func get_person(index, crewmates):
	var name = "Crewmate" + str(index + 1)
	return crewmates.get_node_or_null(name)
