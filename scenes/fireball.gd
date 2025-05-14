extends CharacterBody2D


const SPEED = 200.0
const JUMP_VELOCITY = -400.0
var direction = 1
var pos: Vector2
@onready var area_2d: Area2D = $Area2D

func deduct_health(x: int):
	return

func _ready():
	pos.y-= 20
	if direction == 1:
		pos.x += 35
	global_position=pos

func _physics_process(delta: float) -> void:
	var x=$Area2D.get_overlapping_bodies()
	if x:
		if x[0].parry_frames>0:
			direction=direction*-1
		else:
			x[0].deduct_health(3)
			queue_free()
		
	velocity.x = direction * SPEED
	move_and_slide()
