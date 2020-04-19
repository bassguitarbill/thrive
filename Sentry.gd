extends Node2D

signal gardener_detected

onready var ray = $RayCast2D
onready var body = $Body

var target
var collision_point

var timer

var ray_end

const AI = [
	['face_down'],
	['wait', 2],
	['face_left'],
	['wait', 2],
	['face_up'],
	['wait', 2],
	['face_right'],
	['wait', 2],
]
var instruction_pointer = 0

func _ready():
	$AnimationPlayer.play("Idle")
	next_instruction()
	
func _process(delta):
	update()

func _draw():
	#var ray_end
	if collision_point:
		ray_end = collision_point - position
	else:
		ray_end = ray.cast_to.rotated(ray.rotation)
	draw_line(body.position, ray_end, Color.red, 1)

func _physics_process(delta):
	if ray.is_colliding():
		target = ray.get_collider()
		collision_point = ray.get_collision_point()
		if !target is TileMap:
			ray.enabled = false
			$AudioStreamPlayer.play()

func face_down():
	body.frame = 0
	ray.rotation_degrees = 0
	call_deferred("next_instruction")
	
func face_left():
	body.frame = 3
	ray.rotation_degrees = 90
	call_deferred("next_instruction")
	
func face_up():
	body.frame = 2
	ray.rotation_degrees = 180
	call_deferred("next_instruction")
	
func face_right():
	body.frame = 1
	ray.rotation_degrees = 270
	call_deferred("next_instruction")
	
func wait(s):
	if timer:
		timer.free()
	timer = Timer.new()
	timer.connect("timeout",self,"next_instruction")
	timer.wait_time = s
	add_child(timer)
	timer.start()

func next_instruction():
	var ni = AI[instruction_pointer]
	if ni.size() == 1:
		call(ni[0])
	else:
		callv(ni[0], ni.slice(1, ni.size() + 1))
	instruction_pointer += 1
	if instruction_pointer > AI.size() - 1:
		instruction_pointer = 0


func _on_AudioStreamPlayer_finished():
	emit_signal("gardener_detected")
