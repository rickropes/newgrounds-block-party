extends Node2D

export(PackedScene) var NGNodeScene

var input_state: int = InputState.NOTHING
var shape_type
var selected_nodes := []

signal deselect()

#TODO, use signal to tell children it's in thje dragging state?
func _ready():
	for i in 60:
		Spawn();
		
	var t = get_tree()
	t.call_group('objects', 'connect', 'selected', self, 'select_start')
	t.call_group('objects', 'connect', 'hover', self, 'drag')
	
	connect('deselect', self, '_on_deselect')
	for i in get_children():
		connect('deselect', i, 'unchosen')

func Spawn():
	var newNode = NGNodeScene.instance();
	#newNode.global_position = global_position;
	newNode.position.y = newNode.position.y + rand_range(-10,10);
	newNode.position.x = newNode.position.x + rand_range(-5,5);
	add_child(newNode);
	pass;

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and not event.pressed:
			emit_signal("deselect")

func drag(pfp:NGNode):
	if pfp.type != shape_type: return
	
	var id = pfp.get_instance_id()
	var touching_other = false
	
	var touches = (selected_nodes[len(selected_nodes)-1] as RigidBody2D).get_colliding_bodies()
	for j in touches:
		if j.get_instance_id() == id:
			touching_other = true
			break
	
	if touching_other:
		pfp.become_chosen()
		selected_nodes.append(pfp)

func select_start(child:NGNode):
	input_state = InputState.DRAGGING
	shape_type = child.type
	
	selected_nodes.append(child)

func _on_deselect():
	input_state = InputState.NOTHING
	shape_type = null
	selected_nodes = []
