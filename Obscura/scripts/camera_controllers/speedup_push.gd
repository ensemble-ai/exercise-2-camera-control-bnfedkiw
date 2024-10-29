class_name SpeedupPush
extends CameraControllerBase

@export var push_ratio:float = 0.7
@export var pushbox_top_left:Vector2 = Vector2(-10, 7)
@export var pushbox_bottom_right:Vector2 = Vector2(10, -7)
@export var speedup_zone_top_left:Vector2 = Vector2(-4, 3)
@export var speedup_zone_bottom_right:Vector2 = Vector2(4, -3)


func _ready() -> void:
	draw_camera_logic = true
	super()


func _process(delta: float) -> void:
	if !current:
		return
	
	if draw_camera_logic:
		draw_logic()
		
	var tpos = target.global_position
	var cpos = global_position
	
	# Check horizontal direction
	if (tpos.x < cpos.x + speedup_zone_top_left.x - target.WIDTH / 2.0 \
	&& target.velocity.x < 0) \
	|| (tpos.x > cpos.x + speedup_zone_bottom_right.x + target.WIDTH / 2.0 \
	&& target.velocity.x > 0):
		# Full speed
		if tpos.x < cpos.x + pushbox_top_left.x - target.WIDTH / 2.0 \
		|| tpos.x > cpos.x + pushbox_bottom_right.x + target.WIDTH / 2.0:
			global_position.x += target.velocity.x * delta
		else:
			# Speed ratio
			global_position.x += target.velocity.x * push_ratio * delta
		
	# Check vertical directions
	if (tpos.z < cpos.z - speedup_zone_top_left.y - target.HEIGHT / 2.0 \
	 && target.velocity.z < 0) \
	 || (tpos.z > cpos.z - speedup_zone_bottom_right.y + target.HEIGHT / 2.0 \
	 && target.velocity.z > 0):
		# Full speed
		if tpos.z < cpos.z - pushbox_top_left.y - target.HEIGHT / 2.0 \
		|| tpos.z > cpos.z - pushbox_bottom_right.y + target.HEIGHT / 2.0:
			global_position.z += target.velocity.z * delta
		else:
			# Speed ratio
			global_position.z += target.velocity.z * push_ratio * delta

	super(delta)
	

func draw_logic() -> void:
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()
	
	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	
	var pushbox_left:float = pushbox_top_left.x
	var pushbox_right:float = pushbox_bottom_right.x
	var pushbox_top:float = pushbox_top_left.y
	var pushbox_bottom:float = pushbox_bottom_right.y
	var speedup_zone_left:float = speedup_zone_top_left.x
	var speedup_zone_right:float = speedup_zone_bottom_right.x
	var speedup_zone_top:float = speedup_zone_top_left.y
	var speedup_zone_bottom:float = speedup_zone_bottom_right.y
	
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	
	immediate_mesh.surface_add_vertex(Vector3(pushbox_right, 0, pushbox_top))
	immediate_mesh.surface_add_vertex(Vector3(pushbox_right, 0, pushbox_bottom))
	immediate_mesh.surface_add_vertex(Vector3(pushbox_right, 0, pushbox_bottom))
	immediate_mesh.surface_add_vertex(Vector3(pushbox_left, 0, pushbox_bottom))
	immediate_mesh.surface_add_vertex(Vector3(pushbox_left, 0, pushbox_bottom))
	immediate_mesh.surface_add_vertex(Vector3(pushbox_left, 0, pushbox_top))
	immediate_mesh.surface_add_vertex(Vector3(pushbox_left, 0, pushbox_top))
	immediate_mesh.surface_add_vertex(Vector3(pushbox_right, 0, pushbox_top))
	
	immediate_mesh.surface_add_vertex(Vector3(speedup_zone_right, 0, speedup_zone_top))
	immediate_mesh.surface_add_vertex(Vector3(speedup_zone_right, 0, speedup_zone_bottom))
	immediate_mesh.surface_add_vertex(Vector3(speedup_zone_right, 0, speedup_zone_bottom))
	immediate_mesh.surface_add_vertex(Vector3(speedup_zone_left, 0, speedup_zone_bottom))
	immediate_mesh.surface_add_vertex(Vector3(speedup_zone_left, 0, speedup_zone_bottom))
	immediate_mesh.surface_add_vertex(Vector3(speedup_zone_left, 0, speedup_zone_top))
	immediate_mesh.surface_add_vertex(Vector3(speedup_zone_left, 0, speedup_zone_top))
	immediate_mesh.surface_add_vertex(Vector3(speedup_zone_right, 0, speedup_zone_top))
	
	immediate_mesh.surface_end()

	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = Color.BLACK
	
	add_child(mesh_instance)
	mesh_instance.global_transform = Transform3D.IDENTITY
	mesh_instance.global_position = Vector3(global_position.x, target.global_position.y, global_position.z)
	
	#mesh is freed after one update of _process
	await get_tree().process_frame
	mesh_instance.queue_free()
