extends Node

var now_playing = ""

func play(track):
	if track == now_playing:
		return
	
	now_playing = track
	for child in get_children():
		child.stop()
	match track:
		"Relax":
			$BGMRelax.play()
