class_name PointsArea
extends Area2D

enum Sizes {
	SMALL, MEDIUM, LARGE
}
export(Sizes) var radius = Sizes.SMALL
export(int) var point_shapes = 1 setget set_point_shapes

signal points_all_gone()
func _ready() -> void:
	$CollisionShape2D.shape.radius = (radius + 1) * 50

func set_point_shapes(v:int):
	point_shapes = v
	
	if point_shapes <= 0:
		emit_signal("points_all_gone")