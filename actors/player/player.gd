extends KinematicBody

enum FIGURE_TYPE {
	CROSS,
	CIRCLE
}

export(FIGURE_TYPE) var figure_type = FIGURE_TYPE.CROSS

export var is_using_mouse : bool = true
export var player_material : Material
export var player_figure : PackedScene
export var is_player_active : bool = false

var mouse_pos : Vector2
var velocity = Vector3()

onready var speed : float = 0.05	
signal player_set_figure

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
	if not is_player_active:
		return
	
	if event is InputEventMouseMotion:
		mouse_pos = event.position
	
	if event is InputEventKey:
		process_key()

func _unhandled_input(event):
	if not is_player_active:
		return
		
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == 1:
			var trigger_box : TriggerBox = $"/root/Global".trigger_zone_entered
			if trigger_box:
				var figure : TriggerBox = player_figure.instance()
				trigger_box.add_figure(figure, figure_type)		
				$"/root/Global".trigger_zone_entered = null
				emit_signal("player_set_figure")

func _unhandled_key_input(event):	
	if not is_player_active:
		return

	if event.is_action_pressed("player_choose") and  $"/root/Global".trigger_zone_entered:
		var trigger_box : TriggerBox = $"/root/Global".trigger_zone_entered
		var figure : TriggerBox = player_figure.instance()
		trigger_box.add_figure(figure, figure_type)		
		$"/root/Global".trigger_zone_entered = null
		emit_signal("player_set_figure")
		
func move_player_mouse() -> void:
	var camera = get_parent().get_node("Camera")
	if camera:
		var ray_origin = camera.project_ray_origin(mouse_pos)
		var ray_direction = camera.project_ray_normal(mouse_pos)
		var to = ray_origin + ray_direction * 2.7
		self.transform.origin[0] = to.x
		self.transform.origin[1] = to.y
		self.move_and_collide(velocity)
		
func process_key() -> void:
	velocity = Vector3()
	velocity.x = 0
	velocity.x = 0
	if Input.is_action_pressed("player_forward"):
		velocity.z -= 1
	if Input.is_action_pressed("player_backward"):
		velocity.z += 1
	velocity = velocity.normalized() * speed
	
func activate() -> void:
	is_player_active = true
	self.show()
	
func deactivate() -> void:
	is_player_active = false
	self.hide()

