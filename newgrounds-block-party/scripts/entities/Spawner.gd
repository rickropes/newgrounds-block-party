extends RigidBody2D

export(Enums.ShapeTypes) var shape = Enums.ShapeTypes.TRIANGLE
export(float) var impulse := 0.0
export(bool) var auto := true
export(int) var amount := -1
export(float) var time := 2.0
export(float, -359, 359) var angle := 0
export(bool) var inside := false
export(float) var changeWeigth = -1;
export(bool) var collisionDisabled = false;

onready var collisionShape = $CollisionShape2D;


var direction := Vector2.RIGHT

var spawn_scene: PackedScene
var currentShape;


signal spawned(object)

func _ready() -> void:
	$Icon.frame = shape
	$SpawnTimer.wait_time = time
	if auto:
		$SpawnTimer.start()
	
	# Get scene for spawn_scene TODO
	spawn_scene = Manager.get_shape_scene(shape)
	
	collisionShape.disabled = collisionDisabled;
	
	direction = direction.rotated(deg2rad(angle))


func _on_SpawnTimer_timeout() -> void:
	var _obj = spawn_shape()
	amount -= 1
	if amount == 0:
		$Icon.visible = false
		$SpawnTimer.stop()

func spawn_shape() -> NGNode:
	var obj:NGNode = spawn_scene.instance()
	
	emit_signal("spawned", obj)
	
	var setPosition = global_position;
	
	if(!inside):
		setPosition += (direction * 
		($CollisionShape2D.shape.extents.x + 32))
	
	obj.global_position = setPosition;
	
	obj.apply_central_impulse(direction * impulse)
	
	if(changeWeigth != -1):
		obj.weight = changeWeigth
	
	currentShape = obj;
	return obj


func _on_Spawner_body_entered(body: Node) -> void:
	if body.is_in_group('moving lava'): 
		queue_free()
		amount = 0
		$SpawnTimer.disconnect("timeout", self, '_on_SpawnTimer_timeout')
