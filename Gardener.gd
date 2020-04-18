extends Node2D

const TILE_SIZE = 16
export var TWEEN_DURATION = 0.8

var destination = null
var input = Vector2.ZERO
var ready_to_move = true

var can_move = {
	"right": 0,
	"left": 0,
	"up": 0,
	"down": 0
}

onready var tween = $Tween
onready var animationPlayer = $AnimationPlayer
onready var sprite = $Sprite

func _process(delta):
	if ready_to_move:
		get_input()
		if (input != Vector2.ZERO):
			start_move()
		
func get_input():
	input = Vector2.ZERO
	
	if (Input.is_action_pressed("ui_left") && can_move["left"] == 0):
		input.x -= 1
		animationPlayer.play("WalkLeft")
		return
	if (Input.is_action_pressed("ui_right") && can_move["right"] == 0):
		input.x += 1
		animationPlayer.play("WalkRight")
		return
	if (Input.is_action_pressed("ui_up") && can_move["up"] == 0):
		input.y -= 1
		animationPlayer.play("WalkUp")
		return
	if (Input.is_action_pressed("ui_down") && can_move["down"] == 0):
		input.y += 1
		animationPlayer.play("WalkDown")
		return
		
func start_move():
	var collision_position = input * TILE_SIZE
	#$Area2D.position = collision_position
	destination = (input * TILE_SIZE) + position
	tween.interpolate_property(
		self,
		"position",
		position,
		destination,
		TWEEN_DURATION,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN_OUT
	)
	tween.start()
	ready_to_move = false

func anim_to_idle():
	animationPlayer.stop(true)
	#match (input):
	
	#	Vector2(-1, 0):
			

func _on_CanGoRight_body_entered(body):
	can_move["right"] += 1

func _on_CanGoLeft_body_entered(body):
	can_move["left"] += 1

func _on_CanGoDown_body_entered(body):
	can_move["down"] += 1
	
func _on_CanGoUp_body_entered(body):
	can_move["up"] += 1

func _on_CanGoRight_body_exited(body):
	can_move["right"] -= 1

func _on_CanGoLeft_body_exited(body):
	can_move["left"] -= 1
	
func _on_CanGoDown_body_exited(body):
	can_move["down"] -= 1

func _on_CanGoUp_body_exited(body):
	can_move["up"] -= 1

func _on_Tween_tween_all_completed():
	ready_to_move = true
	print(can_move)
	anim_to_idle()
