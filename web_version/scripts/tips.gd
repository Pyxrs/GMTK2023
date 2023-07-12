extends Label

var current_tip = 0

var tips = [
	"Excrement build up can cause disease.", 
	"Paranoid crewmates wont follow orders.",
	"The janitor has the ability to clean bodies up.",
	"Cult members can get aggressive with numbers.",
	"Sleep is necessary for the crewmates' mental health. ;)",
	"Objects can act strange with a lack of oxygen.",
	"Both mechanics will go to fix the generator if needed.",
]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	text = tips[current_tip]

func _on_timer_timeout():
	current_tip += 1
	if current_tip >= tips.size():
		current_tip = 0
