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
			$BGMRelax.stream.set_loop_begin(1130496)
			$BGMRelax.play()
