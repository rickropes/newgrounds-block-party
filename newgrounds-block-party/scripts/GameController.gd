extends Node2D

export(PackedScene) var NGNodeScene

var input_state: int = Enums.InputState.NOTHING
var shape_type
var selected_nodes := []
onready var pfp_dict = {
	Enums.ShapeTypes.PLAIN_CIRCLE : preload("res://scenes/base_shapes/PlainCircle.tscn")
}

onready var t = get_tree()

func _ready():
	# get rid of this when we start placing in elements ourselves
	for i in 60:
		Spawn();
	
	t.call_group('objects', 'connect', 'selected', self, 'select_start')
	t.call_group('objects', 'connect', 'hover', self, 'drag')
	

func Spawn():
	var newNode = pfp_dict[Enums.ShapeTypes.PLAIN_CIRCLE].instance();
	#newNode.global_position = global_position;
	newNode.position.y = newNode.position.y + rand_range(-10,10);
	newNode.position.x = newNode.position.x + rand_range(-5,5);
	add_child(newNode);

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and not event.pressed:
			deselect()
#			emit_signal("deselect")

func drag(pfp:NGNode):
	if pfp.type != shape_type: return
	
	#var touches = (selected_nodes[len(selected_nodes)-1] as RigidBody2D).get_colliding_bodies()
	var current_chosen = selected_nodes[len(selected_nodes)-1];
	var touches = (current_chosen.collisionArea as Area2D).get_overlapping_bodies();
	
	for j in touches:
		if j == pfp:
			
			#Check if node already exists in line
			if(selected_nodes.has(pfp)):
				#Check if is last one of line
				if(len(selected_nodes) > 1 && selected_nodes[len(selected_nodes)-2] == pfp ):
					current_chosen.unchosen()
					selected_nodes.erase(current_chosen);
					pfp.become_chosen()
			else:
				#Add new node
				current_chosen.become_tail()
				pfp.become_chosen()
				selected_nodes.append(pfp)
			
			break

func select_start(child:NGNode):
	input_state = Enums.InputState.DRAGGING
	shape_type = child.type
	
	selected_nodes.append(child)

func deselect():
	
	t.call_group('objects', 'unchosen')
	
	# use the abilities here before they are cleared
	
	input_state = Enums.InputState.NOTHING
	shape_type = null
	selected_nodes.clear()
