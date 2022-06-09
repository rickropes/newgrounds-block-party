class_name GameController
extends Node2D

var input_state: int = Enums.InputState.NOTHING
var shape_type
var selected_nodes := []
var affectees := []

onready var container := $BodiesContainer

const HEX_FIELD = preload("res://scenes/entities/HexField.tscn")
onready var camera = get_node("../Tracker/Camera2D");

const TRI_IMPULSE = 300
const PENTAGON_RADIUS = 150
const HEX_RADIUS = 100
const OCTAGON_RADIUS = 100
const PARALLELOGRAM_RADIUS = 100

signal entity_spawn(ent)

func _ready():
	for obj in container.get_children():
		spawned(obj)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and not event.pressed:
			deselect()

func _process(_delta):
	
	# Slow Motion
#	if(selected_nodes.size() > 0):
#		Engine.time_scale = 0.1;
#	else:
#		Engine.time_scale = 1

	update();
	pass

func drag(pfp:NGNode):
	if pfp.shape != shape_type: return
	#var touches = (selected_nodes[len(selected_nodes)-1] as RigidBody2D).get_colliding_bodies()
	var current_chosen = selected_nodes[len(selected_nodes)-1];
	if(not is_instance_valid(current_chosen)): return
	var touches = (current_chosen.collisionArea as Area2D).get_overlapping_bodies();
	
	for j in touches:
		if j != pfp: continue
			
		#Check if node already exists in line
		var sel_len = len(selected_nodes)
		if (pfp in selected_nodes):
			#Check if is last one of line
			if (sel_len > 1 and selected_nodes[sel_len-2] == pfp ):
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

func deselect() -> void:
	for i in container.get_children(): i.unchosen()
	
	# use the abilities here before they are cleared
	var sel_len: int = len(selected_nodes)
	var centroid = get_centroid(selected_nodes)
	match shape_type:
		# TRIANGLES
		Enums.ShapeTypes.TRIANGLE:
			$Sfx/Triangle.play()
			
			camera.addShake(10);
			
			var force = (
				# get's the direction between the middle node and the mouse
				get_global_mouse_position() - centroid
			).normalized() * TRI_IMPULSE * sel_len
			
			for tri in selected_nodes: 
				if(is_instance_valid(tri)):
					for i in get_shapes_in_circle(PENTAGON_RADIUS * min(sel_len, 3), tri.global_position):
						if (i as NGNode).shape != Enums.ShapeTypes.TRIANGLE and i.shape != Enums.ShapeTypes.STAR: # and force.dot(i.global_position - centroid) > 0:
							affectees.append(i)
					
					tri.destroy()
			
			for e in affectees:
				(e as RigidBody2D).apply_central_impulse(force)
		
		#PENTAGONS
		Enums.ShapeTypes.PENTAGON:
			var effect_radius = PENTAGON_RADIUS * sel_len
			# list of collision shape positions
			var col_positions := []
			for spike in get_shapes_in_circle(effect_radius, centroid, Enums.ShapeTypes.SPIKY_CIRCLE):
				print(spike);
				#FIXME: need a solution for if pentagon hits parent body
				if spike.shape == Enums.ShapeTypes.SPIKY_CIRCLE: 
					if spike.absorbed == 1:
						continue
				else: continue
						
				var cols = spike.get_children_of_type("CollisionShape2D")
				var sprites = spike.get_children_of_type("Sprite")
				for i in len(cols):
					if cols[i].global_position in col_positions: continue
					
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
					spike.destroy()
			
			for pent in selected_nodes:
				pent.destroy()
				
			for i in col_positions:
				print(i);
				var spiky = Manager.get_shape_scene(Enums.ShapeTypes.PLAIN_CIRCLE).instance()
				container.add_child(spiky)
				spiky.global_position = i

		#SQUARES
		Enums.ShapeTypes.SQUARE:
			var effect_radius = PENTAGON_RADIUS * sel_len
			var col_positions := []
			for circ in get_shapes_in_circle(effect_radius, centroid, Enums.ShapeTypes.PLAIN_CIRCLE):
				col_positions.append(circ.global_position)
				circ.destroy()
			
			for i in col_positions:
				var spiky = Manager.get_shape_scene(Enums.ShapeTypes.SPIKY_CIRCLE).instance()
				spiky.connect('contact', self, 'spiky_contact')
				container.add_child(spiky)
				spiky.global_position = i
				
			for sq in selected_nodes:
				sq.destroy()
				
		#HEXAGONS
		Enums.ShapeTypes.HEXAGON:
			var field = HEX_FIELD.instance()
			
			for hex in selected_nodes:
				hex.mode = RigidBody2D.MODE_STATIC
				hex.get_node("Body").disabled = true
				container.remove_child(hex)
				field.add_child(hex)
				hex.position = Vector2.ZERO
			
			emit_signal("entity_spawn", field)
			field.setup(centroid, HEX_RADIUS * sel_len, 1.5 * sel_len)
			
		#OCTAGONS & PARALLELOGRAM
		Enums.ShapeTypes.OCTAGON, Enums.ShapeTypes.PARALLELOGRAM:
			var effect_radius = OCTAGON_RADIUS * sel_len
			for oct in selected_nodes: oct.destroy()
			
			for obj in get_shapes_in_circle(effect_radius, centroid):
				obj.mode = (
					RigidBody2D.MODE_STATIC 
					if shape_type == Enums.ShapeTypes.OCTAGON 
					and obj.shape != Enums.ShapeTypes.PARALLELOGRAM
					else 
					RigidBody2D.MODE_RIGID
				)
	
	# go back to defaults
	input_state = Enums.InputState.NOTHING
	shape_type = null
	selected_nodes.clear()
	affectees.clear()

func spawned(obj:NGNode):
	if container.is_a_parent_of(obj): return;
	
	container.add_child(obj)
	
	obj.connect('selected', self, 'select_start')
	obj.connect('hover', self, 'drag')
	
	if obj.is_in_group('spiky circle'):
		obj.connect('contact', self, 'spiky_contact')

func spiky_contact(reporter:SpikyCircle, other:SpikyCircle) -> void: 
	# TODO sprites will have other collision shapes so I need to get all of them
	
	if(other.immovable):
		var temp = reporter;
		reporter = other;
		other = temp;
	
	reporter.absorbed += other.absorbed
	other.absorbed = 0
	for i in other.get_children():
		if i is Sprite or i is CollisionShape2D:
			var pos = i.global_position
			i.set_deferred('disabled', true)
			other.remove_child(i)
			reporter.add_child(i)
			i.set_deferred('disabled', false)
			i.global_position = pos
	
	reporter.already_contacted = false
	other.queue_free()

func _draw():
	if shape_type == null: return
	
	# do the drawing here
	
	var sel_len = len(selected_nodes)
	var current_chosen = selected_nodes[sel_len-1];
	
	var centroid = get_centroid(selected_nodes)
	var mouse_pos = get_global_mouse_position()
	match shape_type:
		Enums.ShapeTypes.TRIANGLE:
			var to_mouse = (mouse_pos - centroid).clamped(PENTAGON_RADIUS)
			draw_line(centroid, centroid + to_mouse, Color(0.75, 0.13, 0.1, 0.6), 10);
			
			# draw explosion radius for triangles
			for tri in selected_nodes:
				if(is_instance_valid(tri)):
					if(((tri as NGNode).shape) == Enums.ShapeTypes.TRIANGLE):
						draw_circle(tri.position, PENTAGON_RADIUS, Color(0.75, 0.13, 0.1, 0.2))
		Enums.ShapeTypes.HEXAGON:
			var to_mouse = (mouse_pos - centroid).clamped(HEX_RADIUS * sel_len)
			draw_line(centroid, centroid + to_mouse, Color(1, 1, 0, 0.45))
			draw_circle(centroid, HEX_RADIUS * sel_len, Color(1, 1, 0, 0.45))

func get_centroid(arr) -> Vector2:
	var out = Vector2.ZERO
	for i in arr:
		if(is_instance_valid(i)):
			out += i.global_position
	out /= len(arr)
	
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
