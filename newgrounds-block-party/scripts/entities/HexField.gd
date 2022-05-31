extends Area2D

onready var col = $Body
onready var timer = $Timer

const MULT = 5

func setup(pos:Vector2, radius: float, time: float):
	global_position = pos
	col.shape.radius = radius
	timer.wait_time = time
	timer.start()

func _on_Timer_timeout() -> void:
	queue_free()


