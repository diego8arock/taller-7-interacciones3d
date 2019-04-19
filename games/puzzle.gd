extends Spatial

onready var random_rotations = [0, 90, 180, 270]
onready var random_position_1 = [-1, -1, 0]
onready var random_position_2 = [1, -1, 0]
onready var random_position_3 = [1, 1, 0]
onready var random_position_4 = [-1, 1, 0]
onready var random_select = [1, 2, 3, 4]
onready var nodes_names = ["LeftBottomPiece","RightBottomPiece","RightTopPiece","LeftTopPiece"]

onready var solution = { "LeftBottomPiece": [-1,-1,-0], "RightBottomPiece": [1,-1,0], "RightTopPiece": [1,1,0], "LeftTopPiece": [-1,1,0]  }
onready var solution_degree : float = 0.0

func _ready():
	randomize()
	random_select.shuffle()
	nodes_names.shuffle()
	var positions = []
	for i in random_select:
		var piece = get_node(nodes_names[i - 1])
		match i:
			1:
				positions = random_position_1
			2:
				positions = random_position_2
			3:
				positions = random_position_3
			4:
				positions = random_position_4
		_set_piece_initial_position(piece, positions)
		
func _set_piece_initial_position(node : Spatial, positions) -> void:	
	var rot_index = randi() % 4
	var rotation_y = random_rotations[rot_index]
	
	node.transform.origin[0] = positions[0]
	node.transform.origin[1] = positions[1]
	node.transform.origin[2] = positions[2]
	
	node.rotate(Vector3(0,0,1), rotation_y * PI / 180)
	node.set_position_and_degress(positions[0], positions[1], positions[2], rotation_y * PI / 180)

func _on_Player_player_set_figure(piece_selected, piece_selected_original_position, piece_to_change):
	piece_selected.transform.origin[0] = piece_to_change.position_origin[0]
	piece_selected.transform.origin[1] = piece_to_change.position_origin[1]
	piece_selected.transform.origin[2] = piece_to_change.position_origin[2]
	piece_to_change.transform.origin[0] = piece_selected_original_position[0]
	piece_to_change.transform.origin[1] = piece_selected_original_position[1]
	piece_to_change.transform.origin[2] = piece_selected_original_position[2]
	piece_selected.set_position_and_degress(piece_selected.transform.origin[0], piece_selected.transform.origin[1], piece_selected.transform.origin[2], piece_selected.degress)
	piece_to_change.set_position_and_degress(piece_to_change.transform.origin[0], piece_to_change.transform.origin[1],piece_to_change.transform.origin[2],piece_to_change.degress )
	_evaluate_play()
	
func _evaluate_play() -> void:
	var correct_counter = 0
	for child in self.get_children():
		var child_name = child.name
		if "Piece" in child_name:		
			var position = solution[child_name]
			if child.transform.origin[0] == position[0] and child.transform.origin[1]  == position[1] and child.transform.origin[2]  == position[2] and int(abs(child.rotation.z * 180 / PI)) == solution_degree:
				correct_counter += 1
	if correct_counter == 4:
		print("CORRECT!!")
		get_tree().paused = true

func _on_Player_player_rotate_figure():
	_evaluate_play()
