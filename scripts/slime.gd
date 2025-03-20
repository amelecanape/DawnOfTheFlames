extends Node2D

var SPEED=60

@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if ray_cast_left.is_colliding():
		SPEED=60
		animated_sprite.flip_h = false
	if ray_cast_right.is_colliding():
		SPEED=-60
		animated_sprite.flip_h = true
	position.x+=SPEED*delta
	

@onready var timer: Timer = $Timer

func _on_body_entered(body: Node2D) -> void:
	print("wsh t mort la???")
	if body.dash_frames!=0:
		queue_free()
	else:
		timer.start()
		body.get_node("CollisionShape2D").queue_free()
		Engine.time_scale=0.5


func _on_timer_timeout() -> void:
	get_tree().reload_current_scene()
	Engine.time_scale=1

	
