extends RigidBody2D

export(Enums.ShapeTypes) var shape = Enums.ShapeTypes.TRIANGLE
export(float) var impulse := 0.0
export(bool) var auto := true
export(int) var amount := -1
export(float) var time := 2.0
export(float, -359, 359) var angle := 0
var direction := Vector2.RIGHT

var spawn_scene: PackedScene

signal spawned(object)

func _ready() -> void:
	$Icon.frame = shape
	$SpawnTimer.wait_time = time
	if auto:
		$SpawnTimer.start()
	
	# Get scene for spawn_scene TODO
	spawn_scene = Manager.get_shape_scene(shape)
	
	direction = direction.rotated(deg2rad(angle))


func _on_SpawnTimer_timeout() -> void:
	var _obj = spawn_shape()
	amount -= 1
	if amount == 0:
		$SpawnTimer.stop()

func spawn_shape() -> NGNode:
	var obj:NGNode = spawn_scene.instance()
	
	emit_signal("spawned", obj)
	obj.global_position = global_position + (direction * 
		($CollisionShape2D.shape.extents.x + 32)
	)
	
	obj.apply_central_impulse(direction * impulse)
	return obj
