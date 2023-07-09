extends Panel

func _on_timer_timeout():
	var p = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
	for i in range(15):
		var guy = Global.get_person(i, get_parent().get_parent().get_node("Crewmates"))
		e(i, guy, p)
	$P1.text = str(p[0]) + "\n" + str(p[1]) + "\n" + str(p[2]) + "\n" + str(p[3]) + "\n" + str(p[4]) + "\n" + str(p[5]) + "\n" + str(p[6]) + "\n" + str(p[7])
	$P2.text = str(p[8]) + "\n" + str(p[9]) + "\n" + str(p[10]) + "\n" + str(p[11]) + "\n" + str(p[12]) + "\n" + str(p[13]) + "\n" + str(p[14])

func e(i, guy, array):
	if guy:
		var level = guy.paranoia
		array[i] = snapped(level, 0.1)

func _on_crew_files_pressed():
	show()
