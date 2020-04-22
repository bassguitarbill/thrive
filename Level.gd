extends Node2D

signal update_game_state
signal go_to_map
signal reset_map
signal interaction_finished

var game_state = {}

onready var gardener = $YSort/Gardener

class_name Level

func load_game_state(state):
	self.game_state = state
	
