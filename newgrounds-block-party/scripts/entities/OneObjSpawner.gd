extends "res://scripts/entities/Spawner.gd"

func _process(_delta: float) -> void:
	$Icon.modulate.a = ($SpawnTimer.wait_time - $SpawnTimer.time_left)/$SpawnTimer.wait_time

func spawn_shape():
	$Icon.modulate.a = 0.5
	.spawn_shape().connect("gone", self, "_on_shape_gone")
	
func _on_shape_gone():
	if amount == 0: return
	amount -= 1
	
	$SpawnTimer.start()
	$Icon.modulate.a = 1
