extends RigidBody2D

var selected = false
var speed = 100;
var velocity = Vector2.ZERO;
var area;


func _ready():
	Initialize();
	pass
	
func Initialize():
	
	can_sleep = false;
	
	#Add area2d with collision shape to detect collisions
	area = Area2D.new();
	area.name = "CollisionArea";
	add_child(area);
	area.owner = self;
	
	var collisionArea = $CollisionShape2D.duplicate();
	area.add_child(collisionArea);
	collisionArea.owner = area;
	
	area.connect("body_entered", self, "_on_Area2D_body_entered");
	
	pass;

func _physics_process(delta):
	
	if (selected):
		$Sprite.scale = Vector2(1.1, 1.1);
		z_index = 10;
		
		var canDrop = area.get_overlapping_bodies().size() == 0;
		
		if(canDrop):
			$Sprite.modulate = Color.white;
		else:
			$Sprite.modulate = Color.red;
		
		if (Input.is_action_just_released("mouseLeft") && canDrop):
			ReleaseNode();
		else:
			DragNode();
	else:
		$Sprite.scale = Vector2(1, 1);
	
	pass
	
func ClickNode():
	print("SELECTED");
	selected = true;
	
	mode = RigidBody2D.MODE_STATIC;
	$CollisionShape2D.disabled = true;
	
	pass;

func ReleaseNode():
	selected = false;
	z_index = 0;
	
	mode = RigidBody2D.MODE_RIGID;
	$CollisionShape2D.disabled = false;
	pass;
	
func DragNode():
	global_transform.origin = get_global_mouse_position();
	pass;
	
func _on_NGNode_input_event(viewport, event, shape_idx):
	if Input.is_action_just_pressed("mouseLeft"):
		ClickNode();
	pass;

func _on_Area2D_body_entered(body):
	#print(body);
	pass; # Replace with function body.
