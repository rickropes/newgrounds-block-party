extends AnimatedSprite


export(Enums.ShapeTypes) var permittedShape = Enums.ShapeTypes.TRIANGLE
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	frame = permittedShape;
	$B.frame = permittedShape;
	$Area2D.visible = true;
	
	
	if(global_position.x == $B.global_position.x):
		var top = self;
		var bottom = $B;
		if($B.global_position.y < global_position.y):
			top = $B;
			bottom = self;
			
		$Area2D.global_position = top.global_position-Vector2(32, 32);
		var scaleY = (-top.global_position.y+bottom.global_position.y) / 64 + 1;
		$Area2D.scale = Vector2(1,scaleY);
		$Area2D.visible = true;
		
	elif(global_position.y == $B.global_position.y):
		print("Cool");
		var left = self;
		var right = $B;
		if($B.global_position.x < global_position.x):
			left = $B;
			right = self;
			
		$Area2D.rotation_degrees = -90;
		$Area2D.global_position = left.global_position-Vector2(32, -32);
		var scaleY = (-left.global_position.x+right.global_position.x) / 64 + 1;
		$Area2D.scale = Vector2(1,scaleY);
		$Area2D.visible = true;
		
		
	else:
		queue_free();
	
	
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_body_entered(body):
	if(body is NGNode):
		var ngNode : NGNode = body as NGNode;
		if(ngNode.shape != permittedShape):
			ngNode.destroy();
	
	pass # Replace with function body.
