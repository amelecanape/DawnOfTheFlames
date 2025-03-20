extends Area2D

@onready var timer: Timer = $Timer

func _on_body_entered(body: Node2D) -> void:
	print("wsh t mort la???")
	timer.start()
	body.get_node("CollisionShape2D").queue_free()
	Engine.time_scale=0.5


func _on_timer_timeout() -> void:
	get_tree().reload_current_scene()
	Engine.time_scale=1
