extends Node2D

var score := 0

onready var t := get_tree()
var controller: GameController

const SHAPE_PATH = "res://scenes/base_shapes/"

func _ready() -> void:
	t.call_group('points', 'connect', 'reached_goal', self, "add_points")
	
	controller = t.get_nodes_in_group('controller')[0]
	t.call_group('spawner', 'connect', 'spawned', controller, 'spawned')
#	

func add_points(p:int):
	score += p 

static func get_shape_scene(shape_type):
	var pfp_dict = {
		Enums.ShapeTypes.TRIANGLE : load(SHAPE_PATH + "Triangle.tscn"),
		Enums.ShapeTypes.PLAIN_CIRCLE : load(SHAPE_PATH + "PlainCircle.tscn"),
		Enums.ShapeTypes.SPIKY_CIRCLE : load(SHAPE_PATH + "SpikyCircle.tscn"),
		Enums.ShapeTypes.PENTAGON : load(SHAPE_PATH + "Pentagon.tscn"),
		Enums.ShapeTypes.HEXAGON : load(SHAPE_PATH + "Hexagon.tscn"),
		Enums.ShapeTypes.OCTAGON : load(SHAPE_PATH + "Octagon.tscn"),
		Enums.ShapeTypes.PARALLELOGRAM : load(SHAPE_PATH + "Parallelogram.tscn"),
		Enums.ShapeTypes.SQUARE : load(SHAPE_PATH + "Square.tscn"),
		Enums.ShapeTypes.HEART : load(SHAPE_PATH + "Heart.tscn"),
		Enums.ShapeTypes.STAR : load(SHAPE_PATH + "Star.tscn"),
		Enums.ShapeTypes.ROUND_SQUARE : load(SHAPE_PATH + "RoundSquare.tscn"),
	}
	
	return pfp_dict[shape_type]
