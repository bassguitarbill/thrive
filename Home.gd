extends Node2D

const Gardener = preload("res://Gardener.tscn")

signal go_to_map
signal fill_flower_health
signal flower_grown

var has_plant_food = false

func _on_ToLevel1_body_entered(body):
	emit_signal("go_to_map", 1, 48, 104, "IdleRight")


func _on_Faucet_fill_flower_health():
	emit_signal("fill_flower_health")


func _on_Flower_flower_grown():
	emit_signal("flower_grown")
	
func load_game_state(state):
	has_plant_food = state['has_plant_food']
	if !has_plant_food:
		$YSort/Flower/CollisionShape2D.free()
