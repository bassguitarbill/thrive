extends ColorRect

var flower_health = 1000
var init_margin_left : int
var init_margin_right : int
var margin_scale : float

onready var bar = $ColorRect

func _ready():
	init_margin_left = bar.margin_left
	init_margin_right = bar.margin_right
	margin_scale = (bar.margin_right - bar.margin_left) / flower_health

func _on_Game_set_flower_health(health):
	flower_health = health
	bar.margin_right = init_margin_left + (flower_health * margin_scale)
	if flower_health < 200:
		bar.color = Color.red
	elif flower_health < 500:
		bar.color = Color.yellow
	else:
		bar.color = Color.blue
	
	
