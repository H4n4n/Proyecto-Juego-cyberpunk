class_name ParallaxController extends ParallaxBackground
## Enhanced parallax background controller that manages multiple layers
## and ties scrolling to camera movement for improved visual effects.

## Configuration for parallax layers
@export var enable_auto_scroll := false
@export var auto_scroll_speed := Vector2(20, 0)
@export var camera_influence := 1.0  # How much camera movement affects parallax

var _camera: Camera2D = null
var _last_camera_pos := Vector2.ZERO

func _ready():
	# Find the camera in the scene
	_find_camera()
	if _camera:
		_last_camera_pos = _camera.global_position

func _process(delta: float) -> void:
	if not _camera:
		_find_camera()
		return
	
	# Update parallax based on camera movement
	var camera_pos = _camera.global_position
	var camera_delta = camera_pos - _last_camera_pos
	
	# Apply camera-based scrolling
	scroll_offset += camera_delta * camera_influence
	
	# Apply auto-scroll if enabled
	if enable_auto_scroll:
		scroll_offset += auto_scroll_speed * delta
	
	_last_camera_pos = camera_pos

func _find_camera() -> void:
	"""Find the active camera in the scene."""
	# Look for player with camera
	var players = get_tree().get_nodes_in_group("players")
	if players.is_empty():
		# Try to find any camera
		var cameras = get_tree().get_nodes_in_group("cameras")
		if not cameras.is_empty():
			_camera = cameras[0] as Camera2D
	else:
		var player = players[0]
		if player.has_node("Camera"):
			_camera = player.get_node("Camera") as Camera2D

func set_layer_speed(layer_name: String, motion_scale: Vector2) -> void:
	"""Dynamically set the motion scale of a specific parallax layer."""
	var layer = get_node_or_null(layer_name) as ParallaxLayer
	if layer:
		layer.motion_scale = motion_scale

func add_parallax_layer(layer_name: String, texture: Texture2D, motion_scale: Vector2, offset: Vector2 = Vector2.ZERO) -> ParallaxLayer:
	"""Dynamically add a new parallax layer."""
	var layer = ParallaxLayer.new()
	layer.name = layer_name
	layer.motion_scale = motion_scale
	layer.motion_offset = offset
	
	var sprite = Sprite2D.new()
	sprite.texture = texture
	sprite.centered = false
	
	layer.add_child(sprite)
	add_child(layer)
	
	return layer

func get_layer_count() -> int:
	"""Return the number of parallax layers."""
	var count = 0
	for child in get_children():
		if child is ParallaxLayer:
			count += 1
	return count
