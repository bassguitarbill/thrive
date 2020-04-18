extends Node2D

signal begin_game

var going_to_game = false
func _ready():
	$AnimationPlayer.play("LD46")
	
func _process(_delta):
	if Input.is_action_just_pressed("ui_accept") && !going_to_game:
		going_to_game = true
		emit_signal("begin_game")
	
func _on_AnimationPlayer_animation_finished(anim_name):
	match anim_name:
		"LD46":
			$AnimationPlayer.play("SplashScreens")
		"SplashScreens":
			$AnimationPlayer.play("Logo")
		"Logo":
			$AnimationPlayer.play("Dance")
