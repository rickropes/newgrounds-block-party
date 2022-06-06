extends Node2D

onready var controller = $GameController
onready var pre_spawn_cont = $PreSpawnedContainer
onready var tracker := $Tracker

onready var t := get_tree()

func _ready() -> void:
	randomize()
	
	t.call_group('points', 'connect', 'reached_goal', Manager, "add_points")
	t.call_group('goal', 'connect', 'points_all_gone', self, '_on_points_all_gone')
	
	for obj in pre_spawn_cont.get_children():
		var gp = obj.global_position
		pre_spawn_cont.remove_child(obj)
		controller.spawned(obj)
		obj.global_position = gp
	
	pre_spawn_cont.queue_free()
	t.call_group('spawner', 'connect', 'spawned', controller, 'spawned')

func _process(delta: float) -> void:
	var points_shapes = t.get_nodes_in_group('points')
	var centroid = controller.get_centroid(points_shapes)
	
	if len(points_shapes) > 0:
		tracker.global_position = tracker.global_position.linear_interpolate(centroid, 0.05)
		print(tracker.global_position)

func _on_points_all_gone():
	#TODO: change scene here 
#	t.change_scene_to(levels[wrapi(levels.find(t.current_scene)+1, 0, len(levels))])
	print_debug("It's over")

func _on_entity_spawned(field):
	add_child(field)
