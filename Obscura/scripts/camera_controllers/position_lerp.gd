class_name PositionLerp
extends CameraControllerBase


# Make speeds be a ratio of player speed
@export var follow_speed:float = 0.30
@export var catchup_speed:float = 0.50
@export var leash_distance:float = 7.0

var _target_speed:float = target.BASE_SPEED
var _origin_tolerance:float = catchup_speed


func _ready() -> void:
	super()
	draw_camera_logic = true


func _process(delta: float) -> void:
	if not current:
		return
	
	if draw_camera_logic:
		draw_logic()
		
	# Decide which speed to take a ratio off
	if Input.is_action_just_pressed("ui_accept"):
		_target_speed = target.HYPER_SPEED
	if Input.is_action_just_released("ui_accept"):
		_target_speed = target.BASE_SPEED
	
	# Find distance between target and camera
	var tpos := target.global_position
	var dist_pos := global_position - tpos
	var distance := sqrt(dist_pos.x * dist_pos.x + dist_pos.z * dist_pos.z)
	var target_velocity := target.velocity
	
	# If very close to origin and target is not moving, snap camera to target
	if distance < _origin_tolerance and target_velocity == Vector3(0, 0, 0):
		global_position.x = tpos.x
		global_position.z = tpos.z
	elif distance != 0:
		if distance > leash_distance:
			# Stop camera from getting too far from player
			global_position.x += target.velocity.x * delta
			global_position.z += target.velocity.z * delta
		else:
			# Follow target
			if target_velocity != Vector3(0, 0, 0):
				# Distance = speed * time
				var camera_follow_dist = follow_speed * _target_speed * delta
				# Check target's direction and camera's proximity to it
				if target_velocity.x > 0 and global_position.x < tpos.x:
					global_position.x += camera_follow_dist
				elif target_velocity.x < 0 and tpos.x < global_position.x:
					global_position.x -= camera_follow_dist
					
				if target_velocity.z < 0 and global_position.z > tpos.z:
					global_position.z -= camera_follow_dist
				elif target_velocity.z > 0 and tpos.z > global_position.z:
					global_position.z += camera_follow_dist
					
		# Catchup to target
		if target_velocity == Vector3(0, 0, 0) and tpos != global_position:
			var camera_catchup_dist = catchup_speed * _target_speed * delta
			# Check where camera has to catchup to
			if global_position.x < tpos.x:
				global_position.x += camera_catchup_dist
			elif tpos.x < global_position.x:
				global_position.x -= camera_catchup_dist
				
			if global_position.z < tpos.z:
				global_position.z += camera_catchup_dist
			elif tpos.z < global_position.z:
				global_position.z -= camera_catchup_dist
	super(delta)
	

func draw_logic() -> void:
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()
	
	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	
	var left:float = -2.5
	var right:float = 2.5
	var top:float = -2.5
	var bottom:float = 2.5
	
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	immediate_mesh.surface_add_vertex(Vector3(left, 0, 0))
	immediate_mesh.surface_add_vertex(Vector3(right, 0, 0))
	
	immediate_mesh.surface_add_vertex(Vector3(0, 0, top))
	immediate_mesh.surface_add_vertex(Vector3(0, 0, bottom))
	immediate_mesh.surface_end()

	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = Color.BLACK
	
	add_child(mesh_instance)
	mesh_instance.global_transform = Transform3D.IDENTITY
	mesh_instance.global_position = Vector3(global_position.x, target.global_position.y, global_position.z)
	
	# Mesh is freed after one update of _process
	await get_tree().process_frame
	mesh_instance.queue_free()
