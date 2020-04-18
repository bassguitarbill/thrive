extends Node2D

var destination_map = 0
var destination_coordinates = Vector2(0, 0)
var p_anim

var game_state = {
	'flower_health': 1000,
	
}

signal level_change_complete

onready var ScreenTransition = $ScreenTransition

func _ready():
	pass # Replace with function body.

func _on_Level_go_to_map(map_number, x, y, player_anim):
	destination_map = map_number
	destination_coordinates = Vector2(x, y)
	p_anim = player_anim
	ScreenTransition.start_fade_out()

func _on_ScreenTransition_fade_out_finished():
	
	if has_node("Level"):
		var old_level = $Level
		remove_child(old_level)
		old_level.call_deferred("free")
	
	if has_node("TitleScreen"):
		var title_screen = $TitleScreen
		remove_child(title_screen)
		title_screen.call_deferred("free")
	
	var next_level_resource
	match destination_map:
		0:
			next_level_resource = load("res://Home.tscn")
			$BGM.play("Relax")
		1:
			next_level_resource = load("res://Level1.tscn")
			$BGM.play("Relax")
	var next_level = next_level_resource.instance()
	next_level.name = 'Level'
	add_child_below_node($Top, next_level)
	next_level.connect("go_to_map", self, "_on_Level_go_to_map")
	$Level/YSort/Gardener.position = destination_coordinates
	$Level/YSort/Gardener/AnimationPlayer.play(p_anim)
	$Level/YSort/Gardener.connect('finished_move', self, '_on_Gardener_move')
	emit_signal("level_change_complete", destination_map)
	print('level change complete')


func _on_TitleScreen_begin_game():
	_on_Level_go_to_map(0, 72, 88, "IdleDown")
	
func _on_Gardener_move():
	print('moved!')
	pass
