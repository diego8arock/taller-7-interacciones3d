extends KinematicBody

export var is_using_mouse : bool = true
export var player_material : Material

var mouse_pos : Vector2
var velocity = Vector3()
var is_piece_selected : bool = false
var piece_selected : PuzzlePiece
var piece_selected_original_position

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

onready var speed : float = 0.05	
signal player_set_figure(piece_selected, piece_selected_original_position,  piece_to_change)
signal player_rotate_figure

func _ready():
	if player_material:
    	$MeshInstance.material_override = player_material	
	if is_using_vr:
		_start_vr()

func _process(delta: float) -> void:
	if is_using_vr:
		clientGlove.mainloop()
		clientTracker.mainloop()
		
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
					if not is_piece_selected:
						piece_selected = $"/root/Global".piece_selected				
						if piece_selected:
							piece_selected_original_position = piece_selected.position_origin
							is_piece_selected = true
							piece_selected.disable_collision()
				else:
					if is_piece_selected:
						is_piece_selected = false
						var piece_to_change = $"/root/Global".piece_selected
						emit_signal("player_set_figure", piece_selected, piece_selected_original_position, piece_to_change)
						piece_selected.enable_collision()
						$"/root/Global".piece_selected = null
						piece_selected_original_position = []	
					
		if not(clientTracker.quat[0] == 0 and clientTracker.quat[1] == 0 and clientTracker.quat[2] == 0):
			var quaty = clientTracker.quat[1]
			var posx = clientTracker.pos[0] / traslate_x_sensitiviy
			var posy = clientTracker.pos[1] / traslate_y_sensitiviy
			var posz = clientTracker.pos[2] / traslate_z_sensitiviy
			self.move_and_collide(Vector3(0,-posz,posy),false)
					
func _physics_process(delta):
	if is_using_mouse:
		move_player_mouse()		

func _input(event):	
	if is_using_mouse:
		if event is InputEventMouseMotion:
			mouse_pos = event.position
		
		if event is InputEventKey:
			process_key()

func _unhandled_input(event):	
	if event is InputEventMouseButton and is_using_mouse:
		if event.pressed and event.button_index == 1:
			verify_selected_piece()	

func verify_selected_piece() ->void:
	if not is_piece_selected:
		piece_selected = $"/root/Global".piece_selected				
		if piece_selected:
			piece_selected_original_position = piece_selected.position_origin
			is_piece_selected = true
			piece_selected.disable_collision()
	else:
		is_piece_selected = false
		var piece_to_change = $"/root/Global".piece_selected
		emit_signal("player_set_figure", piece_selected, piece_selected_original_position, piece_to_change)
		piece_selected.enable_collision()
		$"/root/Global".piece_selected = null
		piece_selected_original_position = []			
		
func move_player_mouse() -> void:
	var camera = get_parent().get_node("Camera")
	if camera:
		var ray_origin = camera.project_ray_origin(mouse_pos)
		var ray_direction = camera.project_ray_normal(mouse_pos)
		var to = ray_origin + ray_direction * 4
		self.transform.origin[0] = to.x
		self.transform.origin[1] = to.y
		self.move_and_collide(velocity)
		if is_piece_selected:
			piece_selected.transform.origin[0] = to.x
			piece_selected.transform.origin[1] = to.y
			piece_selected.transform.origin[2] = self.transform.origin[2]
			piece_selected.move_and_collide(velocity)
		
func process_key() -> void:
	if Input.is_action_pressed("player_right"):
		rotate_piece_right()
	if Input.is_action_pressed("player_left"):
		rotate_piece_left()

func rotate_piece_left() -> void:	
	if $"/root/Global".piece_selected and not is_piece_selected:
		$"/root/Global".piece_selected.rotate(Vector3(0,0,1), -90 * PI / 180)
		emit_signal("player_rotate_figure")

func rotate_piece_right() -> void:
	if $"/root/Global".piece_selected and not is_piece_selected:
		$"/root/Global".piece_selected.rotate(Vector3(0,0,1), 90 * PI / 180)
		emit_signal("player_rotate_figure")
		
func _start_vr() -> void:
	clientTracker = vrpnClient.new()
	clientTracker.connect("Tracker0@10.3.137.218")
	clientGlove = vrpnClient.new()
	clientGlove.connect("Glove14Right@localhost")
	fist_values = [3.6, 4.5, 6.3, 2.5, 10.0, 7.5, 2.2, 9.4, 7.5, 3.9, 3.7, 6.6, 3.3, 6.5] 
			

			
			
			