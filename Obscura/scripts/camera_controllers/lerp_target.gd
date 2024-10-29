class_name TargetLerp
extends CameraControllerBase

const SPEED_UP_CAMERA:float = 1.5

# Make speeds be a ratio of player speed
# Add 1 to lead speed to make it faster than the player
@export var lead_speed:float = 1.60
@export var catchup_delay_duration:float = 1.0
@export var catchup_speed:float = 0.7
@export var leash_distance:float = 6.0

var _target_speed:float = target.BASE_SPEED
var _origin_tolerance:float = lead_speed - 1
var _timer:Timer


func _ready() -> void:
	super()
	draw_camera_logic = true


func _process(delta: float) -> void:
	if !current:
		return
	
	if draw_camera_logic:
		draw_logic()
		
	# Decide which speed to take a ratio off
	if Input.is_action_just_pressed("ui_accept"):
		_target_speed = target.HYPER_SPEED
	if Input.is_action_just_released("ui_accept"):
		_target_speed = target.BASE_SPEED
	
	# Find distance between target and camera
	var tpos = target.global_position
	var dist_pos = global_position - tpos
	var distance = sqrt(dist_pos.x * dist_pos.x + dist_pos.z * dist_pos.z)
	var target_velocity = target.velocity

	# If very close to origin and target is not moving, snap camera to target
	if distance < _origin_tolerance && target_velocity == Vector3(0, 0, 0):
		global_position.x = tpos.x
		global_position.z = tpos.z
		distance = 0
		_timer = null
	if distance != 0:
		if distance > leash_distance:
			# Stop camera from getting too far from player
			# If camera is behind player, speed it up to get ahead
			if target_velocity.x > 0 && global_position.x < tpos.x \
			|| target_velocity.x < 0 && tpos.x < global_position.x:
				_timer = null
				global_position.x += SPEED_UP_CAMERA * target.velocity.x * delta
			else:
				# If camera is ahead, don't let it get farther
				global_position.x += target.velocity.x * delta
				
			if target_velocity.z < 0 && global_position.z > tpos.z \
			|| target_velocity.z > 0 && tpos.z > global_position.z:
				_timer = null
				global_position.z += SPEED_UP_CAMERA * target.velocity.z * delta
			else:
				global_position.z += target.velocity.z * delta
		else:
			# Distance = speed * time, use of follow and catchup speed as a ratio
			var camera_lead_dist = lead_speed * _target_speed * delta
			# Follow target
			if target_velocity != Vector3(0, 0, 0):
				# Check target's direction and camera's proximity to it
				if target_velocity.x > 0:
					global_position.x += camera_lead_dist
				elif target_velocity.x < 0:
					global_position.x -= camera_lead_dist
					
				if target_velocity.z < 0:
					global_position.z -= camera_lead_dist
				elif target_velocity.z > 0:
					global_position.z += camera_lead_dist
					
		# Catchup to target
		if target.velocity == Vector3(0, 0, 0):
			if _timer == null:
				_timer = Timer.new()
				add_child(_timer)
				_timer.one_shot = true
				_timer.start(catchup_delay_duration)
			elif _timer.is_stopped():
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
	
	#mesh is freed after one update of _process
	await get_tree().process_frame
	mesh_instance.queue_free()
