extends Node2D

const Gardener = preload("res://Gardener.tscn")

signal go_to_map

func _on_ToHome_body_entered(body):
	emit_signal("go_to_map", 0, 296, 152, "IdleLeft")
