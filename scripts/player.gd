extends CharacterBody2D


const SPEED = 150.0
const JUMP_VELOCITY = -300.0
var last_direction = 1
var double_jump=0
var hover = 0
var hold=15
var hit=1
var cooldown=0
var dash_frames=0
var parry_frames=0
var animation_override=false

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer: Timer = $Timer
@onready var timer_2: Timer = $Timer2

@onready var hitbox_droite: Area2D = $hitbox_droite
@onready var hitbox_gauche: Area2D = $hitbox_gauche
@onready var timermort: Timer = $timermort

@onready var health_bar: ProgressBar = $Camera2D/CanvasLayer/HealthBar

func _ready() -> void:
	health_bar.init_health(10)

var vie=10
func deduct_health(x: int):
	vie=vie-x
	health_bar.set_health(vie)
	if vie<=0:
		$timermort.start()
		$".".get_node("CollisionShape2D").queue_free()
		Engine.time_scale=0.5

func _on_timermort_timeout() -> void:
	get_tree().reload_current_scene()
	Engine.time_scale=1


func animation(direction: int):
	if not animation_override:
		if last_direction>0:
			animated_sprite_2d.flip_h=false
		else:
			animated_sprite_2d.flip_h=true
		
		if is_on_floor():
			if direction!=0:
				animated_sprite_2d.play("run")
			else:
				animated_sprite_2d.play("idle_2")
		else:
			if not hover:
				animated_sprite_2d.play("jump")

func attack():
	animation_override=true;
	if cooldown==0:
		if last_direction==1:
			for x in hitbox_droite.get_overlapping_bodies():
				if x!=$".":
					x.deduct_health(hit)
					if hit==3:
						x.jump()
		else:
			for x in hitbox_gauche.get_overlapping_bodies():
				if x!=$".":
					x.deduct_health(hit)
					if hit==3:
						x.jump()
						cooldown+=1
		cooldown+=1
		timer_2.start()
		if hit==1:
			
			animated_sprite_2d.play("hit_1")
			print("hit1")
			timer.stop()
			timer.start()
			hit+=1
		else:
			if hit==2:
				timer.stop()
				timer.start()
				animated_sprite_2d.play("hit_2")
				print("hit2")
				
				hit+=1
			else:
				animated_sprite_2d.play("hit_3")
				print("hit3")
				timer.stop()
				timer.start()
				hit=1

	

func _on_timer_timeout() -> void:
	print("non")
	hit=1
	
func _on_timer_2_timeout() -> void:
	animation_override=false;
	cooldown-=1
	print(cooldown)

func _physics_process(delta: float) -> void:
	
	if is_on_floor() and not Input.is_action_pressed("ui_accept"):
		hover=0
		hold=30
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and (is_on_floor() or double_jump == 1):
		velocity.y = JUMP_VELOCITY
		if is_on_floor() :
			double_jump=1
		else:
			double_jump = 0
			
	if Input.is_action_pressed("ui_accept") and not is_on_floor():
		if hold!=0:
			hold-=1
		else:
			if hover==0:
				print("oui")
				animated_sprite_2d.play("hover")
			hover=1
			velocity.y=50
		
		
	if Input.is_action_just_pressed("grab"):
		if last_direction==1:
			for x in hitbox_droite.get_overlapping_bodies():
				if x!=$".":
					x.jump()
		else:
			for x in hitbox_gauche.get_overlapping_bodies():
				if x!=$".":
					x.jump()
	
	
	if Input.is_action_just_pressed("parry"):
		if cooldown==0:
			parry_frames=30
			animated_sprite_2d.play("parry")
			animation_override=1
			cooldown=1
			timer_2.start()
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.@onready var player: CharacterBody2D = $"."
	var direction := Input.get_axis("move_left", "move_right")
	if parry_frames>0:
		parry_frames-=1
	if dash_frames ==0:
		
		if direction:
			last_direction=direction
			if not is_on_floor() and hover==1:
				velocity.x = direction * SPEED * 0.2
			else:
				velocity.x = direction * SPEED
		else:
			if is_on_floor():
				velocity.x = move_toward(velocity.x, 0, SPEED)
			else:
				if not is_on_floor() and hover==1:
					velocity.x = move_toward(velocity.x, 0, 15)
				else:
					velocity.x = move_toward(velocity.x, 0, 3.5)
		if Input.is_action_just_pressed("dash"):
			dash_frames=30
			hit=5
			animation_override=1
			animated_sprite_2d.play("dash")
			$".".set_collision_mask_value(2, false)
			velocity.x= last_direction * 1000.0
			if last_direction==1:
				for x in hitbox_droite.get_overlapping_bodies():
					if x!=$".":
						x.deduct_health(hit)
						hit=0
						x.jump()
			else:
				for x in hitbox_gauche.get_overlapping_bodies():
					if x!=$".":
						x.deduct_health(hit)
						hit=0
						x.jump()
		if Input.is_action_just_pressed("attack"):
			attack()
	else:
		dash_frames-=1
		if last_direction==1:
			for x in hitbox_droite.get_overlapping_bodies():
				if x!=$".":
					x.deduct_health(hit)
					hit=0
					x.jump()
				
		else:
			for x in hitbox_gauche.get_overlapping_bodies():
				if x!=$".":
					x.deduct_health(hit)
					hit=0
					x.jump()
		if dash_frames==0:
			animation_override=0
			velocity.x=direction * SPEED
			$".".set_collision_mask_value(2, true)
			hit=1
		else:
			velocity.x=move_toward(velocity.x, SPEED*last_direction, 100.0)
	 
		#if Input.is_action_just_pressed("ui_accept") and !is_on_floor():
		#	velocity.x= 1000
	animation(direction)
	move_and_slide()
