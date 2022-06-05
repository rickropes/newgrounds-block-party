extends "res://scripts/gui/UIHover.gd"

export var levelId = 0;

const levelDic = {
	0: {
		'levelNumber': 'F-1',
		'levelName': 'The Pit',
		'levelPath': 'res://scenes/levels/factory/Factory01.tscn'
	},
	1: {
		'levelNumber': 'F-2',
		'levelName': 'To HELL',
		'levelPath': 'res://scenes/levels/factory/Factory02.tscn'
	},
	2: {
		'levelNumber': 'F-3',
		'levelName': 'To HELL',
		'levelPath': 'res://scenes/levels/factory/Factory03.tscn'
	},
	3: {
		'levelNumber': 'F-4',
		'levelName': 'The Climb',
		'levelPath': 'res://scenes/levels/factory/Factory04.tscn'
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
	
	get_tree().change_scene(levelDic[levelId].levelPath);
	pass # Replace with function body.
