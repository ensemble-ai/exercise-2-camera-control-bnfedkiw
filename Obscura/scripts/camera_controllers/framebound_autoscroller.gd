class_name FrameboundAutoscroller
extends CameraControllerBase


@export var top_left:Vector2 = Vector2(-12.0, 6.0)
@export var bottom_right:Vector2 = Vector2(12.0, -6.0)
@export var autoscroll_speed:Vector3 = Vector3(20.0, 0, 0)


func _ready() -> void:
	draw_camera_logic = true
	super()


func _process(delta: float) -> void:
	if not current:
		return
	
	if draw_camera_logic:
		draw_logic()
		
	# Autoscroll camera + player
	global_position.x += autoscroll_speed.x * delta
	global_position.z += autoscroll_speed.z * delta
	target.global_position.x += autoscroll_speed.x * delta
	target.global_position.z += autoscroll_speed.z * delta
	
	var tpos := target.global_position
	var cpos := global_position
	
	# Make player stay within boundaries
	# Left
	var diff_between_left_edges := (tpos.x - target.WIDTH / 2.0) - (cpos.x + top_left.x)
	if diff_between_left_edges < 0:
		target.global_position.x -= diff_between_left_edges
	# Right
	var diff_between_right_edges:= (tpos.x + target.WIDTH / 2.0) - (cpos.x + bottom_right.x)
	if diff_between_right_edges > 0:
		target.global_position.x -= diff_between_right_edges
	# Top
	var diff_between_top_edges := (tpos.z + target.HEIGHT / 2.0) - (cpos.z + top_left.y)
	if diff_between_top_edges > 0:
		target.global_position.z -= diff_between_top_edges
	# Bottom
	var diff_between_bottom_edges := (tpos.z - target.HEIGHT / 2.0) - (cpos.z + bottom_right.y)
	if diff_between_bottom_edges < 0:
		target.global_position.z -= diff_between_bottom_edges
	
	super(delta)
	

func draw_logic() -> void:
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()
	
	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	
	var left:float = top_left.x
	var right:float = bottom_right.x
	var top:float = top_left.y
	var bottom:float = bottom_right.y
	
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	immediate_mesh.surface_add_vertex(Vector3(right, 0, top))
	immediate_mesh.surface_add_vertex(Vector3(right, 0, bottom))
	
	immediate_mesh.surface_add_vertex(Vector3(right, 0, bottom))
	immediate_mesh.surface_add_vertex(Vector3(left, 0, bottom))
	
	immediate_mesh.surface_add_vertex(Vector3(left, 0, bottom))
	immediate_mesh.surface_add_vertex(Vector3(left, 0, top))
	
	immediate_mesh.surface_add_vertex(Vector3(left, 0, top))
	immediate_mesh.surface_add_vertex(Vector3(right, 0, top))
	immediate_mesh.surface_end()

	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = Color.BLACK
	
	add_child(mesh_instance)
	mesh_instance.global_transform = Transform3D.IDENTITY
	mesh_instance.global_position = Vector3(global_position.x, target.global_position.y, global_position.z)
	
	# Mesh is freed after one update of _process
	await get_tree().process_frame
	mesh_instance.queue_free()
