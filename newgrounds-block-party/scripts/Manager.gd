extends Node2D

var score := 0

onready var t := get_tree()

func _ready() -> void:
	t.call_group('points', 'connect', 'reached_goal', self, "add_points")

func add_points(p:int):
	score += p 
