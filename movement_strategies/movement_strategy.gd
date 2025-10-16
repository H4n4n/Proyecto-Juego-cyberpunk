class_name MovementStrategy extends RefCounted
## Base class for player movement strategies.
## Uses the Strategy pattern to allow different movement behaviors.

func get_walk_speed() -> float:
	"""Return the walk speed for this movement strategy."""
	return 300.0

func get_acceleration() -> float:
	"""Return the acceleration speed for this movement strategy."""
	return get_walk_speed() * 6.0

func get_jump_velocity() -> float:
	"""Return the jump velocity for this movement strategy."""
	return -725.0

func get_gravity_multiplier() -> float:
	"""Return the gravity multiplier for this movement strategy."""
	return 1.0

func apply_movement_modifiers(player: Player, delta: float) -> void:
	"""Apply any special movement modifiers. Override in subclasses."""
	pass

func get_strategy_name() -> String:
	"""Return the name of this strategy."""
	return "Base"
