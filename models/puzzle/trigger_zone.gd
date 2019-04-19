extends Area

class_name TriggerZone
var puzzle_piece
var new_puzzle_piece
var is_game_starting : bool = true

onready var is_mesh_visible = false

func _ready():
	$MeshInstance.visible = is_mesh_visible

func _on_TriggerZone_body_entered(body):
	pass # Replace with function body.

func _on_TriggerZone_body_exited(body):
	pass # Replace with function body.

func _on_TriggerZone_area_entered(area):
	if is_game_starting:
		puzzle_piece = area
		is_game_starting = false
		$Spatial.add_child(area)
	else: 
		new_puzzle_piece = area
	pass # Replace with function body.

func _on_TriggerZone_area_exited(area):
	new_puzzle_piece = null
	pass # Replace with function body.

func _player_set_figure():
	if new_puzzle_piece:
		print("playser set figure")