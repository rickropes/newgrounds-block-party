class_name NGNode
extends RigidBody2D

signal selected(pfp)
signal hover(pfp)

var collisionArea;

#TODO, make unique shapes that change this variable

# Name - Shape - Description
# ===========================
# Default - Circle Shape - No Powers
# Explode - Triangle - Launch others
# Stick - Spiky Circle - Clumps together Nodes
# Unstick - Pentagon - Seperates Nodes (nullifies stick)
# Freeze - Stop Sign - Freezes shapes in place
# Unfreeze - Parallelogram - Unfreezes shapes (nullifies freeze)
# Slow - Hexagon - Slows down node movement
enum NGNodeType{
	DEFAULT, EXPLODE, STICK, UNSTICK, FREEZE, UNFREEZE, SLOW
}
export(NGNodeType) var type = NGNodeType.DEFAULT;

func _ready():
	Intialize();
	pass;

func Intialize():
	can_sleep = false;
	collisionArea = $CollisionArea
	
	$Control/Label.text = str(NGNodeType.keys()[type]);
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
