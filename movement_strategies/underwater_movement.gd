class_name UnderwaterMovement extends MovementStrategy
## Underwater movement strategy with slower speed and modified physics.
## Simulates movement in water or other dense fluids.

func get_walk_speed() -> float:
	return 150.0  # 50% slower than normal

func get_acceleration() -> float:
	return get_walk_speed() * 4.0  # Slower acceleration

func get_jump_velocity() -> float:
	return -400.0  # Much lower jump in water

func get_gravity_multiplier() -> float:
	return 0.3  # Significantly reduced gravity underwater

func apply_movement_modifiers(player: Player, delta: float) -> void:
	# Add water resistance - slow down horizontal movement
	if abs(player.velocity.x) > get_walk_speed():
		player.velocity.x = move_toward(player.velocity.x, 0, 200 * delta)

func get_strategy_name() -> String:
	return "Underwater"
