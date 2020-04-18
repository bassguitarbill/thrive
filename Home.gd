extends Node2D

const Gardener = preload("res://Gardener.tscn")

signal go_to_map

func _on_ToLevel1_body_entered(body):
	emit_signal("go_to_map", 1, 48, 104, "IdleRight")
