extends Node2D

class_name SplashScreen

signal finished

onready var player : AnimationPlayer = $AnimationPlayer
onready var tween : Tween = $Tween

var is_fading_out = false

func _ready():
	tween.connect("tween_completed", self, "on_fadeout_completed")
	player.connect("animation_finished", self, "on_animation_completed")

func begin():
	print(get_name(), 'begin')
	player.play("begin")
	
func fade_out():
	player.stop()
	is_fading_out = true
	tween.interpolate_property(self, "modulate",
		modulate, Color(0.0,0.0,0.0,0.0), 0.2,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()

func on_fadeout_completed(_dink, _donk):
	emit_signal("finished")

func on_animation_completed(_anim_name):
	emit_signal("finished")
