class_name SpikyCircle
extends NGNode

var absorbed := 1
var already_contacted = false
signal contact(reporter, other)
func _ready() -> void:
	shape = Enums.ShapeTypes.SPIKY_CIRCLE

func _on_SpikyCircle_body_entered(body):
	if body.is_in_group('spiky circle'):
		check_contact(body)

func check_contact(body:SpikyCircle):
	if body.shape == shape and not body.already_contacted:
		already_contacted = true
		body.already_contacted = true
		
		if body.get_instance_id() > get_instance_id():
			already_contacted = false
			return
		else:
			body.set_block_signals(true)
			emit_signal('contact', self, body)
		
