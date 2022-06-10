class_name PointsArea
extends Area2D

enum Sizes {
	SMALL, MEDIUM, LARGE
}
export(Sizes) var radius = Sizes.SMALL
export(int) var point_shapes = 1 setget set_point_shapes

var ogPointsShapes = point_shapes;

const SIZE = 75;

signal points_all_gone()
func _ready() -> void:
	$CollisionShape2D.shape.radius = SIZE * (radius + 1)
	
	var scl = 1*(radius + 1)
	$AnimatedSprite.scale = Vector2(scl, scl)

func set_point_shapes(v:int):
#	if point_shapes != ogPointsShapes:
#		var new_mod = Color.green
#		new_mod.g /= point_shapes
	point_shapes = v
	
	if point_shapes <= 0:
		$GoalJingle.play()
		$AnimatedSprite.modulate = Color.green
		emit_signal("points_all_gone")
