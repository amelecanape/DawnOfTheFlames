extends ProgressBar

var max_health

@onready var health_bar: ProgressBar = $"."
@onready var damage_bar: ProgressBar = $DamageBar
@onready var timer: Timer = $Timer


func init_health(x: int):
	max_health=x
	health_bar.value=100
	damage_bar.value=100


func set_health(x: int):
	health_bar.value=x*100/max_health
	print(x*100/max_health)
	timer.start()
	



func _on_timer_timeout() -> void:
	damage_bar.value=health_bar.value
