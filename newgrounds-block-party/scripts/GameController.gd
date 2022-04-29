extends Node2D

var input_state: int = Enums.InputState.NOTHING
var shape_type
var selected_nodes := []
var affectees := []
const SHAPE_PATH = "res://scenes/base_shapes/"
var pfp_dict = {
	Enums.ShapeTypes.TRIANGLE : load(SHAPE_PATH + "Triangle.tscn"),
	Enums.ShapeTypes.PLAIN_CIRCLE : load(SHAPE_PATH + "PlainCircle.tscn"),
	Enums.ShapeTypes.SPIKY_CIRCLE : load(SHAPE_PATH + "SpikyCircle.tscn"),
	Enums.ShapeTypes.PENTAGON : load(SHAPE_PATH + "Pentagon.tscn")
}

# gonna delete this later just need to use this for spawning randomly
var spawn_rand := [Enums.ShapeTypes.TRIANGLE, Enums.ShapeTypes.PLAIN_CIRCLE]

const TRI_IMPULSE = 150

onready var t = get_tree()

func _ready():
	# get rid of this when we start placing in elements ourselves
	for i in 60:
		Spawn();
	
	t.call_group('objects', 'connect', 'selected', self, 'select_start')
	t.call_group('objects', 'connect', 'hover', self, 'drag')
	

func Spawn():
	spawn_rand.shuffle()
	var newNode = pfp_dict[spawn_rand[0]].instance();
	#newNode.global_position = global_position;
	newNode.position.y = newNode.position.y + rand_range(-10,10);
	newNode.position.x = newNode.position.x + rand_range(-5,5);
	add_child(newNode);

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and not event.pressed:
			deselect()

func drag(pfp:NGNode):
	if pfp.type != shape_type: return
	
	#var touches = (selected_nodes[len(selected_nodes)-1] as RigidBody2D).get_colliding_bodies()
	var current_chosen = selected_nodes[len(selected_nodes)-1];
	var touches = (current_chosen.collisionArea as Area2D).get_overlapping_bodies();
	
	for j in touches:
		if j == pfp:
			
			#Check if node already exists in line
			var sel_len = len(selected_nodes)
			if(selected_nodes.has(pfp)):
				#Check if is last one of line
				if(sel_len > 1 && selected_nodes[sel_len-2] == pfp ):
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
	match shape_type:
		Enums.ShapeTypes.TRIANGLE:
			var sel_len: int = len(selected_nodes)
			var force = (
				# get's the direction between the middle node and the mouse
				get_global_mouse_position() - selected_nodes[(sel_len-1)/2].global_position
			).normalized() * (TRI_IMPULSE * sel_len)
			
			for tri in selected_nodes: 
				for i in tri.collisionArea.get_overlapping_bodies():
					if (i as NGNode).type != shape_type:
						affectees.append(i)
				
				tri.queue_free()
			
			for e in affectees:
				(e as RigidBody2D).apply_central_impulse(force)
	
	# go back to defaults
	input_state = Enums.InputState.NOTHING
	shape_type = null
	selected_nodes.clear()
	affectees.clear()
