extends Level

func _on_ToHome_body_entered(body):
	emit_signal("go_to_map", 0, 296, 152, "IdleLeft")

func _on_ToLevel2_body_entered(body):
	emit_signal("go_to_map", 2, 56, 104, "IdleRight")

func _on_Sentry_gardener_detected():
	emit_signal("reset_map")
	
func load_game_state(_state):
	pass
