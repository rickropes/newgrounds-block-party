class_name NGNode
extends RigidBody2D

signal selected(pfp)
signal hover(pfp)

onready var collisionArea = $CollisionArea;

#TODO, make unique shapes that change this variable
var type = Enums.ShapeTypes.PLAIN_CIRCLE

func _ready():
	pass;

func _on_NGNode_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	var mouse_cond = (event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed)
	var touch_cond = (event is InputEventScreenTouch and event.pressed)
	
	if not (mouse_cond or touch_cond): return
	
	emit_signal('selected', self)
	become_chosen()


func _on_NGNode_mouse_entered() -> void:
	emit_signal('hover', self)

#TODO: there will be more stuff here
func become_chosen():
	$Sprite.modulate = Color.yellow
	
func become_tail():
	$Sprite.modulate = Color.red

func unchosen():
	$Sprite.modulate = Color.white
