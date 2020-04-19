extends Area2D

signal interaction_finished
signal get_plant_food

var has_plant_food = true

func interact():
	has_plant_food = false
	$Sprite.frame = 0
	$AudioStreamPlayer.play()
	emit_signal("get_plant_food")

func _on_AudioStreamPlayer_finished():
	emit_signal("interaction_finished")
