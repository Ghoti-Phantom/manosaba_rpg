extends Node3D
var node_obj

func _ready() -> void:
	node_obj = get_tree().get_first_node_in_group("testgp")
	if node_obj:
		print("有")
	
	
