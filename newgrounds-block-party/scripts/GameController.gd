extends Node2D

var NGNodeScene = preload ("res://scenes/NGNode.tscn");

func _ready():
	for i in 60:
		Spawn();
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func Spawn():
	var newNode = NGNodeScene.instance();
	#newNode.global_position = global_position;
	newNode.position.y = newNode.position.y + rand_range(-10,10);
	newNode.position.x = newNode.position.x + rand_range(-5,5);
	add_child(newNode);
	pass;
