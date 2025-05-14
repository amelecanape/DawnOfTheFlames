extends CharacterBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var health_bar: ProgressBar = $HealthBar
@onready var hitbox_droite: Area2D = $hitbox_droite
@onready var hitbox_gauche: Area2D = $hitbox_gauche
@onready var timer: Timer = $Timer

var cooldown=0
var parry_frames=0
var direction=-1
var fireball = preload("res://scenes/fireball.tscn")

func _physics_process(delta: float) -> void:
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

func jump():
	velocity.y=-100

func _ready() -> void:
	health_bar.init_health(10)

var vie=10
func deduct_health(x: int):
	vie=vie-x
	health_bar.set_health(vie)
	if vie<=0:
		queue_free()
	
func _process(delta: float) -> void:
	var r =hitbox_droite.get_overlapping_bodies()
	var l= hitbox_gauche.get_overlapping_bodies()
	if l:
		direction=-1
		animated_sprite_2d.flip_h=false
		if cooldown==0:
			cooldown=1
			timer.start()
	if r:
		direction = 1
		animated_sprite_2d.flip_h=true
		if cooldown==0:
			cooldown=1
			timer.start()
	move_and_slide()
		
func fire():
	var ball = fireball.instantiate()
	ball.direction=direction
	ball.pos = $".".global_position
	$".".add_child(ball)



func _on_timer_timeout() -> void:
	fire()
	cooldown=0
