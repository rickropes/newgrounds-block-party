class_name SpikyCircle
extends NGNode

var absorbed := 1
var already_contacted = false
signal contact(reporter, other)
onready var og_sprite := $Sprite 
onready var og_col := $CollisionShape2D

func _ready() -> void:
	type = Enums.ShapeTypes.SPIKY_CIRCLE

func _on_SpikyCircle_body_entered(body):
	if body.is_in_group('spiky circle'):
		check_contact(body)

func check_contact(body:SpikyCircle):
	if body.type == type and not body.already_contacted:
		already_contacted = true
		body.already_contacted = true
		
		if body.get_instance_id() > get_instance_id():
			already_contacted = false
			return
		else:
			emit_signal('contact', self, body)
		
