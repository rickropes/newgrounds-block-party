extends "res://scripts/entities/Spawner.gd"

export(int) var spawns_amount := 1
var spawns

func _ready() -> void:
	# need to set this in ready, because if the tree isn't set up then it just reads
	# the default value of spawns_amount 
	spawns = spawns_amount

func _process(_delta: float) -> void:
	$Icon.modulate.a = ($SpawnTimer.wait_time - $SpawnTimer.time_left)/$SpawnTimer.wait_time

func spawn_shape():
	mode = RigidBody2D.MODE_RIGID
	$Icon.modulate.a = 0.5
	for i in spawns:
		direction = direction.rotated(deg2rad(360/spawns_amount))
		.spawn_shape().connect("tree_exited", self, "_on_shape_gone")
	
func _on_shape_gone():
	if amount == 0: return
	
	spawns -= 1
	if spawns == 0:
		spawns = spawns_amount
		$SpawnTimer.start()
	
	$Icon.modulate.a = 1
