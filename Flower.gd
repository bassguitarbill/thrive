extends Area2D

signal flower_grown

func interact():
	$AnimationPlayer.playback_speed = 0.3
	$AnimationPlayer.play("Grow")

func _on_AnimationPlayer_animation_finished(anim_name):
	$AnimationPlayer.playback_speed = 1
	emit_signal("flower_grown")
	$AnimationPlayer.play("Dance")
