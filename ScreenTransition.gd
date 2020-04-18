extends Node2D

signal fade_out_finished
signal fade_in_finished

var anim

func _ready():
	anim = $AnimationPlayer

func start_fade_out():
	anim.play("FadeOut")

func start_fade_in():
	anim.play("FadeIn")
	
func _on_AnimationPlayer_animation_finished(anim_name):
	match anim_name:
		"FadeOut":
			emit_signal("fade_out_finished")
		"FadeIn":
			emit_signal("fade_in_finished")


func _on_Game_level_change_complete(_level_num):
	start_fade_in()
