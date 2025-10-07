extends CharacterBody3D
@export var speed: float = 5.0   # 移动速度
@onready var cam: Camera3D = $CameraPivot/Camera3D   # 根据实际节点路径修改
@export var animation_behaviour_script: CharactorAnimationBehaviour
@export var current_state: String
@export var test_velocity: Vector3
var move_dir: Vector3
var idle_velocity: Vector3
var move_velocity: Vector3

func _ready() -> void:
	if !animation_behaviour_script:
		push_warning("未设置有动画功能的脚本节点")

func _process(delta: float) -> void:
	# 该两句仅用于debug
	test_velocity = velocity
	current_state = animation_behaviour_script.script_node_animationtree_behaviour_base.statemechine_playback.get_current_node()
	var input_dir := Vector2.ZERO
	if Input.is_action_pressed("move_forward"):
		input_dir.y += 1
	if Input.is_action_pressed("move_back"):
		input_dir.y -= 1
	if Input.is_action_pressed("move_left"):
		input_dir.x -= 1
	if Input.is_action_pressed("move_right"):
		input_dir.x += 1
	input_dir = input_dir.normalized()
	var forward = -cam.global_transform.basis.z
	var right = cam.global_transform.basis.x
	forward.y = 0
	right.y = 0
	forward = forward.normalized()
	right = right.normalized()
	move_dir = (forward * input_dir.y + right * input_dir.x).normalized()
	if move_dir.x >= 0:
		velocity.x = move_dir.x * speed - 0.01 # 这个0.01是给动画做的调整，反正几乎不影响速度
	else:
		velocity.x = move_dir.x * speed + 0.01
	velocity.z = move_dir.z * speed
	if not is_on_floor():
		velocity.y -= 9.8 * delta
	else:
		velocity.y = 0
	move_velocity = velocity
	if velocity.length_squared() > 0.0004:
		idle_velocity = velocity
		move_and_slide()
	if velocity.length_squared() > 0.1:
		animation_behaviour_script.walk(move_velocity)
	else:
		animation_behaviour_script.idle(idle_velocity)
