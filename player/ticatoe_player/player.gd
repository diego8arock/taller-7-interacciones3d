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

#VR variables
const vrpnClient = preload("res://bin/vrpnClient.gdns")
var clientGlove = null
var clientTracker = null
var fist_values = []
export var is_using_vr : bool = false
export var threshold : float = 2.0
export var traslate_x_sensitiviy : float = 150.0
export var traslate_y_sensitiviy : float = 150.0
export var traslate_z_sensitiviy : float = 150.0

func _ready():
	if player_material:
    	$MeshInstance.material_override = player_material	
	if is_using_vr:
		_start_vr()

func _process(delta):
	if is_using_vr:
		clientGlove.mainloop()
		clientTracker.mainloop()
		
		if not is_player_active:
			return
		
		var is_fist = true;
		#print(clientGlove.analog)
		if(clientGlove.analog.size() == 14):
			for t in range(fist_values.size()):
				var value = fist_values[t] 
				var tracker = clientGlove.analog[t] * 10
				#print( tracker)
				if tracker < value + threshold and tracker > value - threshold:
					is_fist = is_fist and true
				else:
					is_fist = is_fist and false	
				if is_fist:
					_set_figure()
					
		if not(clientTracker.quat[0] == 0 and clientTracker.quat[1] == 0 and clientTracker.quat[2] == 0):
			var quaty = clientTracker.quat[1]
			var posx = clientTracker.pos[0] / traslate_x_sensitiviy
			var posy = clientTracker.pos[1] / traslate_y_sensitiviy
			var posz = clientTracker.pos[2] / traslate_z_sensitiviy
			self.move_and_collide(Vector3(0,-posz,posy),false)
	
func _physics_process(delta):
	if is_player_active:
		if is_using_mouse:
			move_player_mouse()		

func _input(event):	
	if not is_player_active:
		return
	
	if event is InputEventMouseMotion and is_using_mouse:
		mouse_pos = event.position

func _unhandled_input(event):
	if not is_player_active:
		return
		
	if event is InputEventMouseButton and is_using_mouse:
		if event.pressed and event.button_index == 1:
			_set_figure()

func _set_figure() -> void:
	var trigger_box : TriggerBox = $"/root/Global".trigger_zone_entered
	if trigger_box:
		var figure : TriggerBox = player_figure.instance()
		trigger_box.add_figure(figure, figure_type)		
		$"/root/Global".trigger_zone_entered = null
		emit_signal("player_set_figure")
		
func move_player_mouse() -> void:
	var camera = get_parent().get_node("Camera")
	if camera:
		var ray_origin = camera.project_ray_origin(mouse_pos)
		var ray_direction = camera.project_ray_normal(mouse_pos)
		var to = ray_origin + ray_direction * 6
		self.transform.origin[0] = to.x
		self.transform.origin[1] = to.y
		self.transform.origin[2] = 0.812
		self.move_and_collide(velocity)
	
func activate() -> void:
	is_player_active = true
	self.show()
	
func deactivate() -> void:
	is_player_active = false
	self.hide()

func _start_vr() -> void:
	clientTracker = vrpnClient.new()
	clientTracker.connect("Tracker0@10.3.137.218")
	clientGlove = vrpnClient.new()
	clientGlove.connect("Glove14Right@localhost")
	fist_values = [3.6, 4.5, 6.3, 2.5, 10.0, 7.5, 2.2, 9.4, 7.5, 3.9, 3.7, 6.6, 3.3, 6.5] 

