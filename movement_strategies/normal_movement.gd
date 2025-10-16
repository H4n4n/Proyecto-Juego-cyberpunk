class_name NormalMovement extends MovementStrategy
## Normal movement strategy with standard player movement values.

func get_walk_speed() -> float:
	return 300.0

func get_acceleration() -> float:
	return get_walk_speed() * 6.0

func get_jump_velocity() -> float:
	return -725.0

func get_gravity_multiplier() -> float:
	return 1.0

func get_strategy_name() -> String:
	return "Normal"
