extends Node2D

const TILE_SIZE = 16
export var MOVE_TIME = 0.4

signal finished_move
signal interact

var destination = null
var input = Vector2.ZERO
var ready_to_move = true

var can_move = {
	"right": 0,
	"left": 0,
	"up": 0,
	"down": 0
}
var can_interact = 0

onready var tween = $Tween
onready var animationPlayer = $AnimationPlayer
onready var sprite = $Sprite
onready var bump_sound = $AudioStreamPlayer

func _ready():
	animationPlayer.playback_speed = 0.8 / MOVE_TIME

func _process(delta):
	if ready_to_move:
		get_input()
		if (input != Vector2.ZERO):
			start_move()
		
func get_input():
	input = Vector2.ZERO
	if (Input.is_action_pressed("ui_accept") && can_interact > 0):
		emit_signal("interact")
		ready_to_move = false
		return
	
	if (Input.is_action_pressed("ui_left")):
		$CanInteract/CollisionShape2D.position = $CanGoLeft/CollisionShape2D.position
		if can_move["left"] == 0:
			animationPlayer.play("WalkLeft")
			input.x -= 1
		else:
			animationPlayer.play("IdleLeft")
			!bump_sound.playing && bump_sound.play()
		return
		
	if (Input.is_action_pressed("ui_right")):
		$CanInteract/CollisionShape2D.position = $CanGoRight/CollisionShape2D.position
		if can_move["right"] == 0:
			animationPlayer.play("WalkRight")
			input.x += 1
		else:
			animationPlayer.play("IdleRight")
			!bump_sound.playing && bump_sound.play()
		return
		
	if (Input.is_action_pressed("ui_up")):
		$CanInteract/CollisionShape2D.position = $CanGoUp/CollisionShape2D.position
		if can_move["up"] == 0:
			animationPlayer.play("WalkUp")
			input.y -= 1
		else:
			animationPlayer.play("IdleUp")
			!bump_sound.playing && bump_sound.play()
		return
	if (Input.is_action_pressed("ui_down")):
		$CanInteract/CollisionShape2D.position = $CanGoDown/CollisionShape2D.position
		if can_move["down"] == 0:
			animationPlayer.play("WalkDown")
			input.y += 1
		else:
			animationPlayer.play("IdleDown")
			!bump_sound.playing && bump_sound.play()
		return
		
func start_move():
	var collision_position = input * TILE_SIZE
	destination = (input * TILE_SIZE) + position
	tween.interpolate_property(
		self,
		"position",
		position,
		destination,
		MOVE_TIME,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN_OUT
	)
	tween.start()
	ready_to_move = false

func interaction_finished():
	ready_to_move = true

func anim_to_idle():
	animationPlayer.stop(true)

func _on_CanGoRight_body_entered(_body):
	can_move["right"] += 1

func _on_CanGoLeft_body_entered(_body):
	can_move["left"] += 1

func _on_CanGoDown_body_entered(_body):
	can_move["down"] += 1
	
func _on_CanGoUp_body_entered(_body):
	can_move["up"] += 1

func _on_CanGoRight_body_exited(_body):
	can_move["right"] -= 1

func _on_CanGoLeft_body_exited(_body):
	can_move["left"] -= 1
	
func _on_CanGoDown_body_exited(_body):
	can_move["down"] -= 1

func _on_CanGoUp_body_exited(_body):
	can_move["up"] -= 1

func _on_Tween_tween_all_completed():
	emit_signal("finished_move")
	anim_to_idle()

func allow_to_move():
	ready_to_move = true

func _on_CanInteract_area_entered(area):
	connect("interact", area, "interact")
	area.connect("interaction_finished", self, "interaction_finished")
	can_interact += 1

func _on_CanInteract_area_exited(area):
	disconnect("interact", area, "interact")
	area.disconnect("interaction_finished", self, "interaction_finished")
	can_interact -= 1


func _on_Table_interaction_finished():
	allow_to_move()
