extends Area

class_name TriggerBox

enum FIGURE_TYPE {
	CROSS,
	CIRCLE
}

var is_disabled : bool = false

var figure_type = null

func _ready():
	$MeshInstance.visible = false

func _on_TriggerBox_body_entered(body):
	if is_disabled:
		return 
		
	$MeshInstance.visible = true
	if not $"/root/Global".trigger_zone_entered:
		$"/root/Global".trigger_zone_entered = self

func _on_TriggerBox_body_exited(body):
	if is_disabled:
		return 
		
	$MeshInstance.visible = false
	$"/root/Global".trigger_zone_entered = null

func add_figure(figure_n, figure_t):
	self.add_child(figure_n)
	figure_type = figure_t
	is_disabled = true
	$MeshInstance.visible = false