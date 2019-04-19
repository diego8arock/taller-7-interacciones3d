extends Spatial

class_name PuzzlePiece

var selected_material = preload("res://models/pieces/selected_spatialmaterial.tres")
export var original_material : Material
var position_origin = []
var degress : float

func _ready():
	pass
	
func set_selected_material() -> void:
	$CSGCombiner/CSGBox.material = selected_material
	$CSGCombiner/CSGBox/CSGSphere.material = selected_material
	$CSGCombiner/CSGBox/CSGSphere2.material = selected_material

func set_orignal_material() -> void:
	$CSGCombiner/CSGBox.material = original_material
	$CSGCombiner/CSGBox/CSGSphere.material = original_material
	$CSGCombiner/CSGBox/CSGSphere2.material = original_material

func _on_Area_body_entered(body):
	if "Player" in body.name:
		$"/root/Global".piece_selected = self
		set_selected_material()

func _on_Area_body_exited(body):
	if "Player" in body.name:
		set_orignal_material()
		$"/root/Global".piece_selected = null
		
func disable_collision() -> void:
	$CollisionShape.disabled = true
	
func enable_collision() -> void:
	$CollisionShape.disabled = false
	
func set_position_and_degress(x, y, z, deg) -> void:
	position_origin = [x, y, z]
	degress = deg
	
