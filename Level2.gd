extends Node2D

signal go_to_map
signal interaction_finished
signal get_plant_food
	
func _on_ToLevel1_body_entered(body):
	emit_signal("go_to_map", 1, 280, 104, "IdleLeft")

func _on_Table_interaction_finished():
	emit_signal("interaction_finished")
	$YSort/Table/CollisionShape2D.free()

func _on_Table_get_plant_food():
	emit_signal("get_plant_food")

func _on_Sentry_gardener_detected():
	emit_signal("go_to_map", -1, -1, -1, "")
	
func load_game_state(state):
	if(state['has_plant_food']):
		$YSort/Table/CollisionShape2D.free()
		$YSort/Table/Sprite.frame = 0
		
