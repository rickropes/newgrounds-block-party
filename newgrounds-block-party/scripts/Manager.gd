extends Node

var score := 0

onready var t := get_tree()
var controller
var pre_spawn_cont

const SHAPE_PATH = "res://scenes/base_shapes/"
const LEVEL_PATH = "res://scenes/levels/"

var currentLevelNumber;
var currentLevelName;

#onready var nodeArea = t.get_nodes_in_group("goal")[0];

static func get_shape_scene(shape_type) -> PackedScene:
	return {
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
	}[shape_type]
