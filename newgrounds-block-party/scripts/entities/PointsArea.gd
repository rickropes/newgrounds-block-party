extends Area2D

export(int) var radius = 50

func _ready() -> void:
	$CollisionShape2D.shape.radius = radius
