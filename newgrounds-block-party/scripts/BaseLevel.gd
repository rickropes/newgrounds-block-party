extends Node2D

onready var controller = $GameController
onready var pre_spawn_cont = $PreSpawnedContainer
onready var tracker := $Tracker
onready var cam_mover: Tween= $CamMover

onready var t := get_tree()
onready var scn_changer := get_node("/root/SceneChanger")

export(PackedScene) var next_scene

func _ready() -> void:
	randomize()
	
	if not Music.playing:
		Music.play()
	
	t.call_group('points', 'connect', 'reached_goal', Manager, "add_points")
	t.call_group('goal', 'connect', 'points_all_gone', self, '_on_points_all_gone')
	
	controller.connect("entity_spawn", self, "_on_entity_spawned")
	
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

func _on_points_all_gone():
	#TODO: change scene here 
	cam_mover.interpolate_property(
		tracker, 
		"global_position", 
		tracker.global_position,
		$PointsArea.global_position,
		1.5, Tween.TRANS_CUBIC, Tween.EASE_IN
	)
	cam_mover.start()
	#DUNNO IF WORKS TEST LATER
	t.call_group('spawner', 'queue_free')
	t.call_group('objects', 'destroy')
	scn_changer.fade_scene(next_scene, cam_mover)

func _on_entity_spawned(field):
	add_child(field)
