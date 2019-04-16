extends Spatial

func _ready():
	$Player1.activate()
	$Player2.deactivate()
	pass

func _on_Player1_player_set_figure():
	$Player1.deactivate()
	$Player2.activate()
	$Board.evaluate_play("1", $Player1.figure_type)
	set_player_on_start_position($Player2)
	

func _on_Player2_player_set_figure():
	$Player1.activate()
	$Player2.deactivate()
	$Board.evaluate_play("2", $Player2.figure_type)
	set_player_on_start_position($Player1)
		

func set_player_on_start_position(player):
	player.transform.origin[0] = 0
	player.transform.origin[1] = 0
	player.transform.origin[2] = 3

func _on_Board_end_game(player_num):
	print("Player %s won!" % player_num)
	get_tree().paused = true
