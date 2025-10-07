extends Node3D
class_name CharactorAnimationBehaviour
@export var script_node_animationtree_behaviour_base: AnimationtreeBehaviourBase
func _ready() -> void:
	if !script_node_animationtree_behaviour_base:
		push_warning("未设置有node_animationtree_behaviour_base的节点")
		
func walk(input_direction: Vector3):
	script_node_animationtree_behaviour_base.change_state("Move", "req_move")
	script_node_animationtree_behaviour_base.move(input_direction)

func idle(input_direction: Vector3):
	script_node_animationtree_behaviour_base.change_state("Idle", "req_idle")
	script_node_animationtree_behaviour_base.idle(input_direction)
