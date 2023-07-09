extends Label

var current_tip = 0

var tips = [
	"DDDD",
	"DAAADSAD",
	"AAAA",
	"T$#A",
]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	text = tips[current_tip]

func _on_timer_timeout():
	current_tip += 1
	if current_tip >= tips.size():
		current_tip = 0
