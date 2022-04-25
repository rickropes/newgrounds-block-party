class_name NGNode
extends RigidBody2D

signal selected(pfp)
signal hover(pfp)

var collisionArea;

#TODO, make unique shapes that change this variable
var type := "plain"

func _ready():
	Intialize();
	pass;

func Intialize():
	can_sleep = false;

	#Add area2d with collision shape to detect collisions
	collisionArea = Area2D.new();
	collisionArea.name = "CollisionArea";
	add_child(collisionArea);
	collisionArea.owner = self;

	var collisionAreaShape = $CollisionShape2D.duplicate();
	collisionArea.add_child(collisionAreaShape);
	collisionAreaShape.scale = Vector2(1.5, 1.5);
	collisionAreaShape.owner = collisionArea;
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
