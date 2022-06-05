class_name PointsArea
extends Area2D

enum Sizes {
	SMALL, MEDIUM, LARGE
}
export(Sizes) var radius = Sizes.SMALL
export(int) var point_shapes = 1 setget set_point_shapes

var ogPointsShapes = point_shapes;

const size = 75;

signal points_all_gone()
func _ready() -> void:
	$CollisionShape2D.shape.radius = size * (radius + 1)
	
	var scl = 1/(radius + 1)
	$AnimatedSprite.scale = Vector2(scl, scl)

func set_point_shapes(v:int):
	point_shapes = v
	
	if point_shapes <= 0:
		$GoalJingle.play()
		emit_signal("points_all_gone")
