class_name NGNode
extends RigidBody2D

signal selected(pfp)
signal hover(pfp)

onready var collisionArea = $CollisionArea;

#TODO, make unique shapes that change this variable
onready var og_sprite := get_node("Sprite")
onready var og_col := get_node("Body")
export(Enums.ShapeTypes) var shape

func _ready() -> void:
	og_sprite.frame = randi() % og_sprite.hframes

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

# plays when shapes need to be queue_freed
func destroy():
	$AnimationPlayer.play("die")

#TODO: there will be more stuff here
func become_chosen():
	og_sprite.modulate = Color.green
	
func become_tail():
	og_sprite.modulate = Color.red

func unchosen():
	og_sprite.modulate = Color.white

func _integrate_forces(state: Physics2DDirectBodyState) -> void:
	for i in state.get_contact_count():
		var collider = state.get_contact_collider_object(i)
		if not collider is TileMap: continue 
		
		var cpos = state.get_contact_collider_position(i)
		var normal = state.get_contact_local_normal(i)
		var tile_pos = collider.world_to_map(cpos - normal)
		var tile_id = collider.get_cellv(tile_pos)
			
		match tile_id:
			13, 14, 15, 16, 17, 18, 19, 20, 21:
				destroy()


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == 'die':
		queue_free()
