class_name SpikyCircle
extends NGNode

var absorbed := 1
var already_contacted = false
signal contact(reporter, other)
onready var sprite := $Sprite 

func _ready() -> void:
	type = Enums.ShapeTypes.SPIKY_CIRCLE

func _on_SpikyCircle_body_entered(body):
	if body.is_in_group('spiky circle'):
		check_contact(body)

func check_contact(body):
	var shape = body as SpikyCircle
	if shape.type == type and not shape.already_contacted:
		already_contacted = true
		shape.already_contacted = true
		
		if shape.get_instance_id() > get_instance_id():
			already_contacted = false
			return
		else:
			emit_signal('contact', self, body)
		

func become_tail():
	.become_tail()
	set_sprite_mods(Color.red)

func unchosen():
	.unchosen()
	set_sprite_mods(Color.white)

func become_chosen():
	.become_chosen()
	set_sprite_mods(Color.green)

func set_sprite_mods(clr:Color):
	for i in get_children():
		if i is Sprite:
			i.modulate = clr
