extends StaticBody2D

export(Enums.ShapeTypes) var shape = Enums.ShapeTypes.TRIANGLE
export(Vector2) var direction := Vector2.ZERO
export(float) var impulse := 0.0
export(bool) var auto := false
export(int) var amount := -1

var spawn_scene: PackedScene

signal spawned(object)

func _ready() -> void:
	$Icon.frame = shape
	if auto:
		$SpawnTimer.start()
	
	# Get scene for spawn_scene TODO
	spawn_scene = Manager.get_shape_scene(shape)


func _on_SpawnTimer_timeout() -> void:
	var obj = spawn_scene.instance()
	
	emit_signal("spawned", obj)
	obj.global_position = global_position + (direction * ($CollisionShape2D.shape.extents.x/2))
	obj.apply_central_impulse(direction * impulse)
	
	if amount == -1: return
	
	amount -= 1
	if amount == 0:
		$SpawnTimer.stop()
