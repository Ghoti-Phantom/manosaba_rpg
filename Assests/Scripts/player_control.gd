extends CharacterBody3D
@export var speed: float = 5.0   # 移动速度
@onready var cam: Camera3D = $CameraPivot/Camera3D   # 根据实际节点路径修改

func _physics_process(delta: float) -> void:
	var input_dir := Vector2.ZERO

	# 获取输入
	if Input.is_action_pressed("move_forward"):
		input_dir.y += 1
	if Input.is_action_pressed("move_back"):
		input_dir.y -= 1
	if Input.is_action_pressed("move_left"):
		input_dir.x -= 1
	if Input.is_action_pressed("move_right"):
		input_dir.x += 1

	input_dir = input_dir.normalized()

	# 从相机朝向推算世界坐标的移动方向
	var forward = -cam.global_transform.basis.z
	var right = cam.global_transform.basis.x

	# 保持在水平面 (忽略 y)
	forward.y = 0
	right.y = 0
	forward = forward.normalized()
	right = right.normalized()

	var move_dir = (forward * input_dir.y + right * input_dir.x).normalized()

	# 设置速度
	velocity.x = move_dir.x * speed
	velocity.z = move_dir.z * speed

	# 重力处理
	if not is_on_floor():
		velocity.y -= 9.8 * delta
	else:
		velocity.y = 0

	move_and_slide()
