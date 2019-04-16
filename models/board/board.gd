extends Spatial

enum FIGURE_TYPE {
	CROSS,
	CIRCLE
}

#Filas
onready var win_move_1 = [0, 1 ,2]
onready var win_move_2 = [3, 4 ,5]
onready var win_move_3 = [6, 7 ,8]

#Columnas
onready var win_move_4 = [0, 3 ,6]
onready var win_move_5 = [1, 4 ,7]
onready var win_move_6 = [2, 5 ,8]

#Diagonales
onready var win_move_7 = [0, 4, 8]
onready var win_move_8 = [2, 4, 6]

var trigger_pref = "TriggerBox%d"

var move_results = []

signal end_game(player_num)

func _ready():
	pass
	
func evaluate_play(player_num, figure_type):
	move_results.append(_evaluate_move(win_move_1, figure_type))
	move_results.append(_evaluate_move(win_move_2, figure_type))
	move_results.append(_evaluate_move(win_move_3, figure_type))
	
	move_results.append(_evaluate_move(win_move_4, figure_type))
	move_results.append(_evaluate_move(win_move_5, figure_type))
	move_results.append(_evaluate_move(win_move_6, figure_type))
	
	move_results.append(_evaluate_move(win_move_7, figure_type))
	move_results.append(_evaluate_move(win_move_8, figure_type))
	
	for m in move_results:
		if m:			
			emit_signal("end_game", player_num)
	
	pass

func _evaluate_move(move, figure_type) -> bool:
	var is_win : bool = true
	for i in move:
		var trigger_box_name = trigger_pref % i
		var trigger_box : TriggerBox = get_node(trigger_box_name)
		is_win = is_win and trigger_box.figure_type == figure_type
	return is_win
		
		
		
		