class_name NGNode
extends RigidBody2D

signal selected(pfp)
signal hover(pfp)

onready var collisionArea = $CollisionArea;

#TODO, make unique shapes that change this variable
onready var og_sprite := get_node("Sprite") as Sprite
onready var og_col := get_node("CollisionShape2D") as CollisionShape2D
export(Enums.ShapeTypes) var shape

func _on_NGNode_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	var mouse_cond = (event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed)
	var touch_cond = (event is InputEventScreenTouch and event.pressed)
	
	if not (mouse_cond or touch_cond): return
	
	emit_signal('selected', self)
	become_chosen()


func _on_NGNode_mouse_entered() -> void:
	emit_signal('hover', self)

func get_children_of_type(t:String) -> Array:
	var out := []
	for i in get_children():
		if i.is_class(t):
			out.append(i)
			
	return out

#TODO: there will be more stuff here
func become_chosen():
	og_sprite.modulate = Color.green
	
func become_tail():
	og_sprite.modulate = Color.red

func unchosen():
	og_sprite.modulate = Color.white
