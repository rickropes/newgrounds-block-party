extends NGNode

export(int) var points
signal reached_goal(p)

func _on_CollisionArea_area_entered(area: Area2D) -> void:
	if area.is_in_group('goal'):
		emit_signal("reached_goal", points)
