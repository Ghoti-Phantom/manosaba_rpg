extends Camera3D

@export var target: Node3D                     # 要跟随的目标
@export var offset_node: Node3D # 默认相机偏移
@export var init_rotation: Vector3
@export var move_speed: float = 100           # 相机移动速度
@export var collision_margin: float = 0.3      # 避障前的安全距离

var desired_position: Vector3
var offset: Vector3

func _ready():
	if not target:
		push_warning("Camera target is not set!")
	if offset_node:
		offset = global_position - offset_node.global_position
	#desired_position = global_transform.origin + offset

func _physics_process(_delta):
	if not target:
		return
	desired_position = global_transform.origin + offset
	# 射线检测遮挡
	var space_state = get_world_3d().direct_space_state
	var ray_query = PhysicsRayQueryParameters3D.create(
		target.global_transform.origin,
		offset_node.global_position + offset
	)
	ray_query.exclude = [target]
	ray_query.collide_with_areas = false
	ray_query.collide_with_bodies = true

	var result = space_state.intersect_ray(ray_query)

	if result:
		# 遇到遮挡，将相机移动到碰撞点前方
		var collision_point: Vector3 = result.position
		var direction: Vector3 = (desired_position - target.global_transform.origin).normalized()
		var safe_position: Vector3 = collision_point - direction * collision_margin
		#global_transform.origin = global_transform.origin.lerp(safe_position, delta * move_speed)
		global_transform.origin = safe_position
	else:
		# 无遮挡，回到理想位置
		#global_transform.origin = global_transform.origin.lerp(offset_node.global_position + offset, delta * move_speed)
		global_transform.origin = offset_node.global_position + offset
	# 保持摄像机始终看向目标
	look_at(target.global_transform.origin, Vector3.UP)
