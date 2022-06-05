extends CanvasLayer

var audioMuted = false;
var audioSoundIcon = preload("res://art/gui/volume-high.png");
var audioMutedIcon = preload("res://art/gui/volume-off.png");

var streamVolume = 1;
var fxVolume = 1;

var isPaused = false;

func _ready():
	#streamVolume = AudioServer.get_stream_global_volume_scale();
	#fxVolume = AudioServer.get_fx_global_volume_scale();
	
	if(Manager.currentLevelNumber != null):
		$UI/TopPart/LevelName.text = Manager.currentLevelNumber + ":  " + Manager.currentLevelName;
	else:
		$UI/TopPart/LevelName.text = "";
	
	pass

func _process(delta):
	if(Input.is_action_just_pressed("ui_cancel")):
		if(isPaused):
			_on_ContinueButton_pressed();
		else:
			_on_PauseButton_pressed();
			
	pass

func _on_PauseButton_pressed():
	isPaused = true;
	
	$PauseMenu.visible = isPaused;
	$UI.visible = !isPaused;
	get_tree().paused = isPaused;
	pass


func _on_ContinueButton_pressed():
	isPaused = false;
	
	$PauseMenu.visible = isPaused;
	$UI.visible = !isPaused;
	get_tree().paused = isPaused;
	
	pass # Replace with function body.


func _on_QuitButton_pressed():
	get_tree().paused = false;
	get_tree().change_scene("res://scenes/MainMenu.tscn");
	pass # Replace with function body.


func _on_SoundButton_pressed():
	audioMuted = !audioMuted;
	if(audioMuted):
		# Mute audio
		$UI/TopPart/HBoxContainer/SoundButton.icon = audioMutedIcon;
	else:
		# Un-Mute audio
		$UI/TopPart/HBoxContainer/SoundButton.icon = audioSoundIcon;
	
	pass # Replace with function body.