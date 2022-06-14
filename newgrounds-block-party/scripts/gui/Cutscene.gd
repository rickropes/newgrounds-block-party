extends Node2D

onready var scn_changer = get_node("/root/SceneChanger")
#onready var next_scene = preload("res://scenes/MainMenu.tscn")
export var path_to_next = "MainMenu.tscn"
var next_scene


func _ready() -> void:
	Music.stop()
	$AnimationPlayer.play("cutscene")
	next_scene = load("res://scenes/" + path_to_next)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_mask == BUTTON_LEFT:
			get_tree().change_scene("res://scenes/" + path_to_next)
		

func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == 'cutscene':
		scn_changer.fade_scene(next_scene)
#		get_tree().change_scene("res://scenes/MainMenu.tscn")
