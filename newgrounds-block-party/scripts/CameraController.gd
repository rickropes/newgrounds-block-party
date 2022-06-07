extends Camera2D

var currentShake = 0.0;
var shake_amount = 1.0

func _ready():

	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(currentShake > 0):
		set_offset(Vector2( \
			rand_range(-1.0, 1.0) * currentShake, \
			rand_range(-1.0, 1.0) * currentShake \
		))
		currentShake = lerp(currentShake, 0, 0.1);
	pass

func addShake(ammount):
	currentShake += ammount;
	currentShake = clamp(currentShake, 0, 30);
	pass;
