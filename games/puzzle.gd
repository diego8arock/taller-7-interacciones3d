extends Spatial

onready var random_rotations = [0, 90, 180, 270]
onready var random_position_1 = [-1, -1, 0]
onready var random_position_2 = [1, -1, 0]
onready var random_position_3 = [1, 1, 0]
onready var random_position_4 = [-1, 1, 0]
onready var random_select = [1, 2, 3, 4]
onready var nodes_names = ["LeftBottomPiece","RightBottomPiece","RightTopPiece","LeftTopPiece"]
onready var clockwise_solution = ["LeftTopPiece","RightTopPiece","RightBottomPiece","LeftBottomPiece"]

onready var solution = { "LeftBottomPiece": [-1,-1,-0], "RightBottomPiece": [1,-1,0], "RightTopPiece": [1,1,0], "LeftTopPiece": [-1,1,0]  }

onready var solution_1 = { "LeftTopPiece": [-1,1,0], "RightTopPiece": [1,1,0], "RightBottomPiece": [1,-1,0], "LeftBottomPiece": [-1,-1,-0] }
onready var solution_degree_1 : int = 0
onready var solution_2 = { "RightTopPiece": [-1,1,0], "RightBottomPiece": [1,1,0], "LeftBottomPiece": [1,-1,0], "LeftTopPiece": [-1,-1,-0] } 
onready var solution_degree_2 : int = 90
onready var solution_3 = { "RightBottomPiece": [-1,1,0], "LeftBottomPiece": [1,1,0], "LeftTopPiece": [1,-1,0], "RightTopPiece": [-1,-1,-0] } 
onready var solution_degree_3 : int = -180
onready var solution_4 = { "LeftBottomPiece": [-1,1,0], "LeftTopPiece": [1,1,0], "RightTopPiece": [1,-1,0], "RightBottomPiece": [-1,-1,-0] } 
onready var solution_degree_4 : int = -90


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
	if _evalute_clockwise_solution():
		print("CORRECT!!")
		get_tree().paused = true

func _on_Player_player_rotate_figure():
	_evaluate_play()

func _evalute_clockwise_solution() -> bool:
	
	var positions_nodes = []
	
	for child in self.get_children():
		var child_name = child.name
		if "Piece" in child_name:	
			positions_nodes.append(child_name)	
			
	var result = false
	result = result or _is_solution_correct(positions_nodes, solution_1, solution_degree_1)
	result = result or _is_solution_correct(positions_nodes, solution_2, solution_degree_2)
	result = result or _is_solution_correct(positions_nodes, solution_3, solution_degree_3)
	result = result or _is_solution_correct(positions_nodes, solution_4, solution_degree_4)
	
	return result
	
func _is_solution_correct(response, solution, degrees) -> bool:
	var correct_counter = 0
	for r in response:
		var node = self.get_node(r)
		var sol = solution[r]
		var deg = int(node.rotation.z * 180 / PI)
		if node.transform.origin[0] == sol[0] and node.transform.origin[1]  == sol[1] and node.transform.origin[2]  == sol[2]:
			if _is_degree_in_range(deg,degrees):
				correct_counter += 1		
	return correct_counter == 4

func _is_degree_in_range(response, solution) -> bool:
	return response > (solution - 2) and response < (solution + 2)

	
