extends Node2D

var destination_map = 0
var destination_coordinates = Vector2(0, 0)
var p_anim

var game_state = {
	'flower_health': 1000,
	'game_over': false,
	'has_plant_food': false,
}

signal level_change_complete
signal set_flower_health
signal player_is_allowed_to_move
signal game_over

onready var ScreenTransition = $ScreenTransition

func _ready():
	pass # Replace with function body.

func _on_Level_go_to_map(map_number, x, y, player_anim):
	if (map_number != -1):
		destination_map = map_number
		destination_coordinates = Vector2(x, y)
		p_anim = player_anim
	ScreenTransition.start_fade_out()

func _on_ScreenTransition_fade_out_finished():
	if game_state['game_over']:
		game_over()
		return
	
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
		2:
			next_level_resource = load("res://Level2.tscn")
			$BGM.play("Relax")
	var next_level = next_level_resource.instance()
	next_level.name = 'Level'
	add_child_below_node($Top, next_level)
	next_level.connect("go_to_map", self, "_on_Level_go_to_map")
	
	var gardener = get_node('Level/YSort/Gardener')
	gardener.position = destination_coordinates
	gardener.get_node('AnimationPlayer').play(p_anim)
	gardener.connect('finished_move', self, '_on_Gardener_move')
	$Level.connect('fill_flower_health', self, 'fill_flower_health')
	$Level.connect('flower_grown', self, 'flower_grown')
	$Level.connect('get_plant_food', self, 'get_plant_food')
	connect("player_is_allowed_to_move", gardener, "allow_to_move")
	$Level.load_game_state(game_state)

	$HUD.visible = true
	emit_signal("level_change_complete", destination_map)

func _on_TitleScreen_begin_game():
	_on_Level_go_to_map(0, 72, 88, "IdleDown")
	
func _on_Gardener_move():
	game_state['flower_health'] -= 6.5
	emit_signal("set_flower_health", game_state['flower_health'])
	if game_state['flower_health'] <= 0:
		game_state['game_over'] = true
		emit_signal("game_over")
		ScreenTransition.start_fade_out()
		$BGM.play('Game Over')
	else:
		emit_signal("player_is_allowed_to_move")

func fill_flower_health():
	game_state['flower_health'] = 1000
	emit_signal("set_flower_health", game_state['flower_health'])
	
func flower_grown():
	$AnimationPlayer.play("YouWin")

func get_plant_food():
	game_state['has_plant_food'] = true
	emit_signal("player_is_allowed_to_move")
	
func game_over():
	$AnimationPlayer.play("GameOver")
	var old_level = $Level
	remove_child(old_level)
	old_level.call_deferred("free")

func _on_BGMGameOver_finished():
	get_tree().reload_current_scene()
