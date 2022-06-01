extends Control

var hovering = false;

func _process(delta):
	if(hovering):
		rect_scale = lerp(rect_scale, Vector2(1.2,1.2), 0.5);
	else:
		rect_scale = lerp(rect_scale, Vector2(1,1), 0.9);
		
	pass

func _on_mouse_entered():
	hovering = true;
	pass

func _on_mouse_exited():
	hovering = false;
	pass # Replace with function body.

func _on_visibility_changed():
	hovering = false;
	pass # Replace with function body.
