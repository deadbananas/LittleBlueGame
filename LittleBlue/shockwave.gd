extends ColorRect  # or whatever node type you're using

@export var node_2d: Node2D # Which node to apply this shader to

@onready var camera_2d := get_viewport().get_camera_2d()

func set_distortion_center(world_position: Vector2) -> void:
	material.set_shader_parameter("radius", 0.25)
	print(material.get_shader_parameter("radius"))
	if camera_2d == null: camera_2d = Camera2D.new()
	
	# Get the current viewport size
	var viewport_size: Vector2 = get_viewport_rect().size
	
	# Get the camera's center position (accounts for smoothing and limits)
	var camera_center: Vector2 = camera_2d.get_screen_center_position()
	
	# Calculate screen position (normalize to 0.0 - 1.0 range)
	var screen_position: Vector2 = (
		# First convert world position to screen coordinates
		(world_position - camera_center) * camera_2d.zoom +  # Apply camera zoom
		viewport_size / 2  # Center offset
	)
	
	# Convert to normalized coordinates (0-1 range)
	var normalized_position = screen_position / viewport_size
	
	
	visible = true
	material.set_shader_parameter("center", normalized_position)
	var tween = get_tree().create_tween()
	tween.tween_property(material, "shader_parameter/radius", 1, 0.5)
	tween.tween_property(material, "shader_parameter/strength", 0.1, 0.5)
	await  tween.finished
	tween.tween_property(material, "shader_parameter/radius", 0, 0.5)
	material.set_shader_parameter("radius", 0.25)
	material.set_shader_parameter("strength", 0)
	get_parent().queue_free()
