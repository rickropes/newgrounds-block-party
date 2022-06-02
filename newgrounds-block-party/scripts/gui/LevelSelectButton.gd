extends "res://scripts/gui/UIHover.gd"

export var levelId = 0;

const levelDic = {
	0: {
		'levelNumber': '1-1',
		'levelName': 'The Pit',
		'levelPath': 'res://scenes/levels/factory/Factory01.tscn'
	},
	1: {
		'levelNumber': '1-2',
		'levelName': 'To HELL',
		'levelPath': 'res://scenes/levels/factory/Factory02.tscn'
	}
}


func _ready():
	Manager._ready();
	
	pass


func _process(delta):
	pass

func _on_pressed():
	Manager.currentLevelNumber = levelDic[levelId].levelNumber;
	Manager.currentLevelName = levelDic[levelId].levelName;
	
	get_tree().change_scene_to(Manager.levels[levelId]);
	pass # Replace with function body.
