extends KinematicBody

export var is_using_mouse : bool = true
export var player_material : Material
var mouse_pos : Vector2
onready var speed : float = 0.05
var velocity = Vector3()
onready var is_player_active : bool = false	

func _ready():
	if player_material:
    	$MeshInstance.material_override = player_material
		

func _process(delta):
	pass
	
func _physics_process(delta):
	if is_player_active:
		if is_using_mouse:
			move_player_mouse()		

func _input(event):
	if event is InputEventMouseMotion:
		mouse_pos = event.position
	
	if event is InputEventKey:
		process_key()
		
func move_player_mouse():
	var camera = get_parent().get_node("Camera")
	if camera:
		var ray_origin = camera.project_ray_origin(mouse_pos)
		var ray_direction = camera.project_ray_normal(mouse_pos)
		var to = ray_origin + ray_direction * 2.7
		self.transform.origin[0] = to.x
		self.transform.origin[1] = to.y
		self.move_and_collide(velocity)
		
func process_key():
	velocity = Vector3()
	velocity.x = 0
	velocity.x = 0
	if Input.is_action_pressed("player_forward"):
		velocity.z -= 1
	if Input.is_action_pressed("player_backward"):
		velocity.z += 1
	velocity = velocity.normalized() * speed
	

