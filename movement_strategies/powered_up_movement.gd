class_name PoweredUpMovement extends MovementStrategy
## Powered-up movement strategy with enhanced speed and jump capabilities.
## Used when player has active power-ups.

func get_walk_speed() -> float:
	return 450.0  # 50% faster than normal

func get_acceleration() -> float:
	return get_walk_speed() * 6.0

func get_jump_velocity() -> float:
	return -870.0  # 20% higher jump

func get_gravity_multiplier() -> float:
	return 0.9  # Slightly reduced gravity for floatier feel

func get_strategy_name() -> String:
	return "PoweredUp"
