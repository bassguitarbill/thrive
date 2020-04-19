extends Area2D

signal interaction_finished
signal fill_flower_health

func interact():
	$AudioStreamPlayer.play()
	
func _on_AudioStreamPlayer_finished():
	emit_signal("interaction_finished")
	emit_signal("fill_flower_health")
