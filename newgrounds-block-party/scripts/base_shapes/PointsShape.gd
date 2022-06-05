extends NGNode

export(int) var points
signal reached_goal(p)




func _on_CollisionArea_area_entered(area: PointsArea) -> void:
	if not area.is_in_group('goal'): return
	area.point_shapes -= 1
	
	print_debug(name);
	
	emit_signal("reached_goal", points)
	queue_free()
