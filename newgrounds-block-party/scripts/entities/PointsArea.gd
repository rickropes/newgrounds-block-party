class_name PointsArea
extends Area2D

export(int) var radius = 50
export(int) var point_shapes = 1 setget set_point_shapes

signal points_all_gone()

func _ready() -> void:
	$CollisionShape2D.shape.radius = radius

func set_point_shapes(v:int):
	point_shapes = v
	
	if point_shapes <= 0:
		emit_signal("points_all_gone")
