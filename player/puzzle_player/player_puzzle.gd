extends KinematicBody

export var is_using_mouse : bool = true
export var player_material : Material

var mouse_pos : Vector2
var velocity = Vector3()
var is_piece_selected : bool = false
var piece_selected : PuzzlePiece
var piece_selected_original_position


onready var speed : float = 0.05	
signal player_set_figure(piece_selected, piece_selected_original_position,  piece_to_change)
signal player_rotate_figure

func _ready():
	if player_material:
    	$MeshInstance.material_override = player_material	

func _process(delta):
	pass
	
func _physics_process(delta):
	if is_using_mouse:
		move_player_mouse()		

func _input(event):	
	if event is InputEventMouseMotion:
		mouse_pos = event.position
	
	if event is InputEventKey:
		process_key()

func _unhandled_input(event):	
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == 1:
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
		var to = ray_origin + ray_direction * 2.7
		self.transform.origin[0] = to.x
		self.transform.origin[1] = to.y
		self.move_and_collide(velocity)
		if is_piece_selected:
			piece_selected.transform.origin[0] = to.x
			piece_selected.transform.origin[1] = to.y
			piece_selected.transform.origin[2] = self.transform.origin[2]
			piece_selected.move_and_collide(velocity)
		
func process_key() -> void:
	velocity = Vector3()
	velocity.x = 0
	velocity.x = 0
	if Input.is_action_pressed("player_forward"):
		velocity.z -= 1
	if Input.is_action_pressed("player_backward"):
		velocity.z += 1
	velocity = velocity.normalized() * speed
	
	if Input.is_action_pressed("player_right"):
		if $"/root/Global".piece_selected and not is_piece_selected:
			$"/root/Global".piece_selected.rotate(Vector3(0,0,1), 90 * PI / 180)
			emit_signal("player_rotate_figure")
	if Input.is_action_pressed("player_left"):
		if $"/root/Global".piece_selected and not is_piece_selected:
			$"/root/Global".piece_selected.rotate(Vector3(0,0,1), -90 * PI / 180)
			emit_signal("player_rotate_figure")
			
			
			
			
			
			