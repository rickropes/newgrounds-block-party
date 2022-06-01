extends CanvasLayer

var audioMuted = false;
var audioSoundIcon = preload("res://art/gui/volume-high.png");
var audioMutedIcon = preload("res://art/gui/volume-off.png");

var streamVolume = 1;
var fxVolume = 1;

func _ready():
	#streamVolume = AudioServer.get_stream_global_volume_scale();
	#fxVolume = AudioServer.get_fx_global_volume_scale();
	pass

func _on_PauseButton_pressed():
	$PauseMenu.visible = true;
	$UI.visible = false;
	get_tree().paused = true;
	pass


func _on_ContinueButton_pressed():
	$PauseMenu.visible = false;
	$UI.visible = true;
	get_tree().paused = false;
	pass # Replace with function body.


func _on_QuitButton_pressed():
	print("NOOOOOOOOOOOOOOOOOOOOOOO");
	pass # Replace with function body.


func _on_SoundButton_pressed():
	audioMuted = !audioMuted;
	if(audioMuted):
		# Mute audio
		$UI/HBoxContainer/SoundButton.icon = audioMutedIcon;
	else:
		# Un-Mute audio
		$UI/HBoxContainer/SoundButton.icon = audioSoundIcon;
	
	pass # Replace with function body.
