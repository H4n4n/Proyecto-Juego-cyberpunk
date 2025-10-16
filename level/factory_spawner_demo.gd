extends Node2D
## Demo script showing how to use the Factory pattern to spawn game objects.
## This can be attached to the level or a spawner node.

# References to factories
var enemy_factory: EnemyFactory
var power_up_factory: PowerUpFactory
var collectible_factory: CollectibleFactory

func _ready():
	# Initialize factories
	enemy_factory = EnemyFactory.create()
	power_up_factory = PowerUpFactory.create()
	collectible_factory = CollectibleFactory.create()
	
	print("Factories initialized successfully")

func spawn_enemy(position: Vector2) -> Enemy:
	"""Spawn an enemy at the specified position using the factory."""
	var enemy = enemy_factory.create_object(position) as Enemy
	get_parent().add_child(enemy)
	print("Enemy spawned at: ", position)
	return enemy

func spawn_enemy_with_speed(position: Vector2, walk_speed: float) -> Enemy:
	"""Spawn an enemy with custom walk speed."""
	var params = {"walk_speed": walk_speed}
	var enemy = enemy_factory.create_object_with_params(position, params) as Enemy
	get_parent().add_child(enemy)
	print("Enemy spawned at: ", position, " with speed: ", walk_speed)
	return enemy

func spawn_power_up(position: Vector2, type: int = 0, duration: float = 5.0) -> Node2D:
	"""Spawn a power-up collectible at the specified position."""
	var params = {"type": type, "duration": duration}
	var power_up = power_up_factory.create_object_with_params(position, params)
	get_parent().add_child(power_up)
	print("Power-up spawned at: ", position, " type: ", type)
	return power_up

func spawn_coin(position: Vector2) -> Coin:
	"""Spawn a coin collectible at the specified position."""
	var coin = collectible_factory.create_object(position) as Coin
	get_parent().add_child(coin)
	print("Coin spawned at: ", position)
	return coin

# Example: Spawn objects on key press for testing
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		match event.keycode:
			KEY_1:
				# Spawn enemy at mouse position
				spawn_enemy(get_global_mouse_position())
			KEY_2:
				# Spawn speed boost power-up
				spawn_power_up(get_global_mouse_position(), PowerUpFactory.PowerUpType.SPEED_BOOST)
			KEY_3:
				# Spawn jump boost power-up
				spawn_power_up(get_global_mouse_position(), PowerUpFactory.PowerUpType.JUMP_BOOST)
			KEY_4:
				# Spawn shield power-up
				spawn_power_up(get_global_mouse_position(), PowerUpFactory.PowerUpType.SHIELD)
			KEY_5:
				# Spawn coin
				spawn_coin(get_global_mouse_position())
