extends Node3D
class_name AnimationtreeBehaviourBase
# 包含了共有的行为树切换状态方法。
# 共有方法编写参考于ema的状态机
var animationtree_node: AnimationTree
var animationtree_tree_root: AnimationNodeStateMachine
var statemechine_playback: AnimationNodeStateMachinePlayback
#region 状态切换变量区
@export var req_move: bool = false
@export var req_idle: bool = false
#endregion
func _ready() -> void:
	animationtree_node = $AnimationTree
	animationtree_tree_root = animationtree_node.get("tree_root")
	statemechine_playback = animationtree_node.get("parameters/playback")

#func change_state_with_stcheck(current_state: States.StatesEnum, target_state: States.StatesEnum) -> bool:
func change_state(target_state: String, ...state_names) -> bool:
	if target_state == statemechine_playback.get_current_node():
		return false
	else:
		for name_temp in state_names:
			if name_temp in self:
				self.set(name_temp, true)
			else:
				push_warning("在调整为true时找不到可被设置的属性名称，将跳过该次设置")
				continue
		await get_tree().process_frame
		for name_temp in state_names:
			if name_temp in self:
				self.set(name_temp, false)
			else:
				push_warning("在调整为false时找不到可被设置的属性名称，将跳过该次设置")
				continue
		return true

func move(input_direction: Vector3):
	var normalized_input_direction = input_direction.normalized()
	if input_direction.length_squared() > 0.5:
		if abs(normalized_input_direction.x) >= abs(normalized_input_direction.z):
			if normalized_input_direction.x >= 0:
				animationtree_node.set("parameters/Move/blend_position", Vector2(0, 1))
			else:
				animationtree_node.set("parameters/Move/blend_position", Vector2(0, -1))
		else:
			if normalized_input_direction.z >= 0:
				animationtree_node.set("parameters/Move/blend_position", Vector2(1, 0))
			else:
				animationtree_node.set("parameters/Move/blend_position", Vector2(-1, 0))
			
func idle(input_direction: Vector3):
	var normalized_input_direction = input_direction.normalized()
	if abs(normalized_input_direction.x) >= abs(normalized_input_direction.z):
		if normalized_input_direction.x >= 0:
			animationtree_node.set("parameters/Idle/blend_position", Vector2(0, 1))
		else:
			animationtree_node.set("parameters/Idle/blend_position", Vector2(0, -1))
	else:
		if normalized_input_direction.z >= 0:
			animationtree_node.set("parameters/Idle/blend_position", Vector2(1, 0))
		else:
			animationtree_node.set("parameters/Idle/blend_position", Vector2(-1, 0))
