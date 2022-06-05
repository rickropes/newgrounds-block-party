extends Camera2D


export(NodePath) var nodeToFollow
var node = null;
var spawnerNode = null;
var followNode = null;


export var followVertical = false;
export var verticalFollowLimits = Vector2(0, 0);
export var followHorizontal = false;
export var horizontalFollowLimits = Vector2(0, 0);
var projectResolution = Vector2.ZERO;

var spawnerClass = preload("res://scripts/entities/Spawner.gd");


func _ready():
	projectResolution=get_viewport().size
	
	# Change ../PreSpawnedContainer/NAME -> ../GameController/BodiesContainer/NAME
	var nodePath = str(nodeToFollow);
	nodePath = nodePath.replace("PreSpawnedContainer", "GameController/BodiesContainer")
	node = get_node(nodePath);
	
	if(node is spawnerClass):
		spawnerNode = node;
	else:
		followNode = node;
	
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if(spawnerNode != null):
		followNode = spawnerNode.currentShape
	
	
	if(followNode != null && is_instance_valid(followNode)):
		if(followVertical):
			position.y = clamp(followNode.position.y-projectResolution.y/2, verticalFollowLimits.x, verticalFollowLimits.y);
		if(followHorizontal):
			position.x = clamp(followNode.position.x-projectResolution.x/2, horizontalFollowLimits.x, horizontalFollowLimits.y);
	pass
