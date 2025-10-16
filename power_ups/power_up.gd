class_name PowerUp extends Node
## Base class for power-up decorator pattern.
## Power-ups modify player stats by wrapping/decorating the player's capabilities.

var duration: float = 5.0
var active: bool = false
var player: Player = null

func _init(p_duration: float = 5.0):
	duration = p_duration

func apply(p_player: Player) -> void:
	"""Apply the power-up effect to the player."""
	player = p_player
	active = true
	_on_apply()

func remove() -> void:
	"""Remove the power-up effect from the player."""
	if active:
		_on_remove()
		active = false

func _on_apply() -> void:
	"""Override this method in derived classes to apply specific effects."""
	pass

func _on_remove() -> void:
	"""Override this method in derived classes to remove specific effects."""
	pass

func get_modified_speed(base_speed: float) -> float:
	"""Override to modify player speed."""
	return base_speed

func get_modified_jump(base_jump: float) -> float:
	"""Override to modify player jump velocity."""
	return base_jump

func has_shield() -> bool:
	"""Override to provide shield protection."""
	return false
