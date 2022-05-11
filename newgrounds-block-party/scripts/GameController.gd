extends Node2D

var input_state: int = Enums.InputState.NOTHING
var shape_type
var selected_nodes := []
var affectees := []
const SHAPE_PATH = "res://scenes/base_shapes/"
onready var pfp_dict = {
	Enums.ShapeTypes.TRIANGLE : load(SHAPE_PATH + "Triangle.tscn"),
	Enums.ShapeTypes.PLAIN_CIRCLE : load(SHAPE_PATH + "PlainCircle.tscn"),
	Enums.ShapeTypes.SPIKY_CIRCLE : load(SHAPE_PATH + "SpikyCircle.tscn"),
	Enums.ShapeTypes.PENTAGON : load(SHAPE_PATH + "Pentagon.tscn"),
	Enums.ShapeTypes.HEXAGON : load(SHAPE_PATH + "Hexagon.tscn"),
}

# gonna delete this later just need to use this for spawning randomly
const SPAWN_RAND := [
	Enums.ShapeTypes.TRIANGLE, 
	Enums.ShapeTypes.PLAIN_CIRCLE,
	Enums.ShapeTypes.SPIKY_CIRCLE,
	Enums.ShapeTypes.PENTAGON,
	Enums.ShapeTypes.HEXAGON,
]

const TRI_IMPULSE = 200
const PENTAGON_RADIUS = 100
const HEX_RADIUS = 200

onready var t = get_tree()

func _ready():
	# get rid of this when we start placing in elements ourselves
	for i in 60:
		Spawn();
	
	t.call_group('objects', 'connect', 'selected', self, 'select_start')
	t.call_group('objects', 'connect', 'hover', self, 'drag')
	t.call_group('spiky circle', 'connect', 'contact', self, 'spiky_contact')
	

func Spawn():
	SPAWN_RAND.shuffle()
	var newNode = pfp_dict[SPAWN_RAND[0]].instance();
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
			if (selected_nodes.has(pfp)):
				#Check if is last one of line
				if (sel_len > 1 && selected_nodes[sel_len-2] == pfp ):
					current_chosen.unchosen()
					selected_nodes.erase(current_chosen);
					pfp.become_chosen()
			else:
				#Add new node
				current_chosen.become_tail()
				pfp.become_chosen()
				selected_nodes.append(pfp)
			
			break

func select_start(child:NGNode) -> void:
	input_state = Enums.InputState.DRAGGING
	shape_type = child.type
	
	selected_nodes.append(child)
	
	#DEBUG

func deselect() -> void:
	t.call_group('objects', 'unchosen')
	
	# use the abilities here before they are cleared
	var sel_len: int = len(selected_nodes)
	var centroid = get_centroid()
	match shape_type:
		# TRIANGLES
		Enums.ShapeTypes.TRIANGLE:
			var force = (
				# get's the direction between the middle node and the mouse
				get_global_mouse_position() - centroid
			).normalized() * TRI_IMPULSE * sel_len
			
			for tri in selected_nodes: 
				for i in tri.collisionArea.get_overlapping_bodies():
					if (i as NGNode).type != shape_type and force.dot(i.global_position - centroid) > 0:
						affectees.append(i)
				
				tri.queue_free()
			
			for e in affectees:
				(e as RigidBody2D).apply_central_impulse(force)
		
		#PENTAGONS
		Enums.ShapeTypes.PENTAGON:
			var effect_radius = PENTAGON_RADIUS * sel_len
			# list of collision shape positions
			var col_positions := []
			for pent in selected_nodes:
				for spike in pent.collisionArea.get_overlapping_bodies():
					#FIXME: need a solution for if pentagon hits parent body
					if spike.type == Enums.ShapeTypes.SPIKY_CIRCLE: 
						if spike.absorbed == 1:
							continue
					else: continue
					var spike_children = spike.get_children()
					
					for sp_child in spike_children:
						var dist_vec = sp_child.global_position - centroid
						# check if object is within distance of centroid
						if dist_vec.length() > effect_radius and col_positions.has(sp_child.global_position): continue
						
						var cl = sp_child.get_class()
						var ch = spike.get_children_of_type(cl)
						var ind = ch.find(sp_child)
						if spike.og_col == sp_child or spike.og_sprite == sp_child:
							var is_sprite = sp_child is Sprite
							var next = wrapi(ind + 1, 0, len(ch))
							var next_child = ch[next]
							
							# TODO fix this nightmare
							if is_sprite:
								spike.og_sprite = next_child
							else:
								spike.og_col = next_child
							
#							continue
							
						if sp_child is CollisionShape2D:
							spike.absorbed -= 1
							col_positions.append(sp_child.global_position)
							
						sp_child.queue_free()
				
				pent.queue_free()
				
			for i in col_positions:
				var spiky = pfp_dict[Enums.ShapeTypes.SPIKY_CIRCLE].instance()
				add_child(spiky)
				spiky.global_position = i
		Enums.ShapeTypes.HEXAGON:
			for hex in selected_nodes:
				hex.mode = RigidBody2D.MODE_STATIC
	
	# go back to defaults
	input_state = Enums.InputState.NOTHING
	shape_type = null
	selected_nodes.clear()
	affectees.clear()

func spiky_contact(reporter:SpikyCircle, other:SpikyCircle) -> void: 
	# TODO sprites will have other collision shapes so I need to get all of them
	reporter.absorbed += other.absorbed
	other.absorbed = 0
	for i in other.get_children():
		if i is Sprite or i is CollisionShape2D:
			var pos = i.global_position
			other.remove_child(i)
			reporter.add_child(i)
			i.global_position = pos
	
	reporter.already_contacted = false
	other.queue_free()


func get_centroid() -> Vector2:
	var out = Vector2.ZERO
	for i in selected_nodes:
		out += i.global_position
	out /= len(selected_nodes)
	
	return out
