extends Node2D

var input_state: int = Enums.InputState.NOTHING
var shape_type
var selected_nodes := []
var affectees := []

onready var container = $BodiesContainer

const SHAPE_PATH = "res://scenes/base_shapes/"
onready var pfp_dict = {
	Enums.ShapeTypes.TRIANGLE : load(SHAPE_PATH + "Triangle.tscn"),
	Enums.ShapeTypes.PLAIN_CIRCLE : load(SHAPE_PATH + "PlainCircle.tscn"),
	Enums.ShapeTypes.SPIKY_CIRCLE : load(SHAPE_PATH + "SpikyCircle.tscn"),
	Enums.ShapeTypes.PENTAGON : load(SHAPE_PATH + "Pentagon.tscn"),
	Enums.ShapeTypes.HEXAGON : load(SHAPE_PATH + "Hexagon.tscn"),
	Enums.ShapeTypes.SQUARE : load(SHAPE_PATH + "Square.tscn"),
}

# gonna delete this later just need to use this for spawning randomly
const SPAWN_RAND := [
	Enums.ShapeTypes.TRIANGLE, 
	Enums.ShapeTypes.PLAIN_CIRCLE,
	Enums.ShapeTypes.SPIKY_CIRCLE,
	Enums.ShapeTypes.PENTAGON,
	Enums.ShapeTypes.HEXAGON,
	Enums.ShapeTypes.SQUARE,
]

const TRI_IMPULSE = 200
const PENTAGON_RADIUS = 175
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
	container.add_child(newNode);

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and not event.pressed:
			deselect()

func drag(pfp:NGNode):
	if pfp.shape != shape_type: return
	
	#var touches = (selected_nodes[len(selected_nodes)-1] as RigidBody2D).get_colliding_bodies()
	var current_chosen = selected_nodes[len(selected_nodes)-1];
	var touches = (current_chosen.collisionArea as Area2D).get_overlapping_bodies();
	
	for j in touches:
		if j != pfp: continue
			
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
	shape_type = child.shape
	
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
					if (i as NGNode).shape != shape_type and force.dot(i.global_position - centroid) > 0:
						affectees.append(i)
				
				tri.queue_free()
			
			for e in affectees:
				(e as RigidBody2D).apply_central_impulse(force)
		
		#PENTAGONS
		Enums.ShapeTypes.PENTAGON:
			var effect_radius = PENTAGON_RADIUS * sel_len
			# list of collision shape positions
			var col_positions := []
			for spike in get_shapes_in_circle(effect_radius, centroid, Enums.ShapeTypes.SPIKY_CIRCLE):
				#FIXME: need a solution for if pentagon hits parent body
				if spike.shape == Enums.ShapeTypes.SPIKY_CIRCLE: 
					if spike.absorbed == 1:
						continue
				else: continue
						
				var cols = spike.get_children_of_type("CollisionShape2D")
				var sprites = spike.get_children_of_type("Sprite")
				for i in len(cols):
					if col_positions.has(cols[i].global_position): continue
					
					spike.absorbed -= 1
					col_positions.append(cols[i].global_position)
					
					if cols[i] == spike.og_col:
						var next = wrapi(i + 1, 0, len(cols))
						spike.og_col = cols[next]
					elif sprites[i] == spike.og_sprite:
						var next = wrapi(i + 1, 0, len(sprites))
						spike.og_sprite = sprites[next]
					
					cols[i].queue_free()
					sprites[i].queue_free()
				
				if spike.absorbed <= 0:
					spike.queue_free()
			
			for pent in selected_nodes:
				pent.queue_free()
				
			for i in col_positions:
				var spiky = pfp_dict[Enums.ShapeTypes.PLAIN_CIRCLE].instance()
				container.add_child(spiky)
				spiky.global_position = i

		#SQUARES
		Enums.ShapeTypes.SQUARE:
			var effect_radius = PENTAGON_RADIUS * sel_len
			var col_positions := []
			for circ in get_shapes_in_circle(effect_radius, centroid, Enums.ShapeTypes.PLAIN_CIRCLE):
				col_positions.append(circ.global_position)
				circ.queue_free()
			
			for i in col_positions:
				var spiky = pfp_dict[Enums.ShapeTypes.SPIKY_CIRCLE].instance()
				spiky.connect('contact', self, 'spiky_contact')
				container.add_child(spiky)
				spiky.global_position = i
				
			for sq in selected_nodes:
				sq.queue_free()
				
		#HEXAGONS (TODO)
		Enums.ShapeTypes.HEXAGON:
			for hex in selected_nodes:
				hex.mode = RigidBody2D.MODE_STATIC
				hex.get_node("Body").disabled = true
	
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

func get_shapes_in_circle(radius:float, point:Vector2, type = null) -> Array:
	var children = container.get_children()
	var out := []
	
	for i in children:
		if type != null and i.shape != type: continue
		
		if type == Enums.ShapeTypes.SPIKY_CIRCLE:
			var cols = i.get_children_of_type("CollisionShape2D")
			for k in len(cols):
				if (cols[k].global_position - point).length() <= radius:
					out.append(i)
					break
			continue
		
		var vec = i.global_position - point
		if vec.length() <= radius:
			out.append(i)
	
	return out

func _draw() -> void:
	if shape_type == null: return
	
	# do the drawing here
