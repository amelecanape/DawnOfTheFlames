extends Node2D


@onready var label: Label = $Label
@onready var health_bar: ProgressBar = $HealthBar

func _ready() -> void:
	health_bar.init_health(10)

var vie=10
func deduct_health(x: int):
	vie=vie-x
	health_bar.set_health(vie)
	if vie<=0:
		queue_free()
	
