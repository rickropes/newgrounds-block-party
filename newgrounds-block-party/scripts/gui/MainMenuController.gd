extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	if(Manager.currentLevelName != null):
		$Holder.rect_position = Vector2(-1024, 0);
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Start_pressed():
	#$Holder.rect_position = $Holder.rect_position.linear_interpolate(Vector2(-1024, 0), 0.2);
#	$Tween.interpolate_property($Holder, "rect_position", Vector2(0,0), Vector2(-1024,0), 0.5, Tween.TRANS_CUBIC);
#	$Tween.start();
	get_tree().change_scene("res://scenes/levels/factory/TrianglePractice.tscn")
	pass # Replace with function body.


func _on_back_credits_pressed():
	$Tween.interpolate_property($Holder, "rect_position", Vector2(1024,0), Vector2(0,0), 0.5, Tween.TRANS_CUBIC);
	$Tween.start();
	pass # Replace with function body.


func _on_back_level_pressed():
	$Tween.interpolate_property($Holder, "rect_position", Vector2(-1024,0), Vector2(0,0), 0.5, Tween.TRANS_CUBIC);
	$Tween.start();
	pass # Replace with function body.


func _on_Credits_pressed():
	$Tween.interpolate_property($Holder, "rect_position", Vector2(0,0), Vector2(1024,0), 0.5, Tween.TRANS_CUBIC);
	$Tween.start();
	pass # Replace with function body.
