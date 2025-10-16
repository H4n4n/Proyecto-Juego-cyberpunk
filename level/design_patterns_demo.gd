extends Node
## Comprehensive example demonstrating all three design patterns.
## This script can be attached to the level to showcase the patterns.

var enemy_factory: EnemyFactory
var power_up_factory: PowerUpFactory
var collectible_factory: CollectibleFactory
var player: Player

func _ready():
	print("=== Design Patterns Demo ===")
	print("")
	
	# Initialize factories
	enemy_factory = EnemyFactory.create()
	power_up_factory = PowerUpFactory.create()
	collectible_factory = CollectibleFactory.create()
	print("✓ Factories initialized (Factory Pattern)")
	
	# Find player
	var players = get_tree().get_nodes_in_group("players")
	if not players.is_empty():
		player = players[0] as Player
		print("✓ Player found with PowerUpManager (Decorator Pattern)")
		print("✓ Player has MovementStrategy (Strategy Pattern)")
	else:
		push_warning("No player found in scene")
	
	print("")
	print("Controls:")
	print("  1-5: Spawn objects (Factory Pattern)")
	print("  F1-F3: Change movement strategy (Strategy Pattern)")
	print("  Collect spawned power-ups to test Decorator Pattern")
	print("")

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		var spawn_pos = Vector2(400, 300)  # Center of screen
		
		match event.keycode:
			KEY_1:
				# Test Factory Pattern - Spawn Enemy
				var enemy = enemy_factory.create_object(spawn_pos)
				get_tree().current_scene.add_child(enemy)
				print("Factory: Spawned Enemy at ", spawn_pos)
			
			KEY_2:
				# Test Factory Pattern - Spawn Speed Boost
				var params = {"type": PowerUpFactory.PowerUpType.SPEED_BOOST, "duration": 5.0}
				var power_up = power_up_factory.create_object_with_params(spawn_pos, params)
				get_tree().current_scene.add_child(power_up)
				print("Factory: Spawned Speed Boost power-up at ", spawn_pos)
			
			KEY_3:
				# Test Factory Pattern - Spawn Jump Boost
				var params = {"type": PowerUpFactory.PowerUpType.JUMP_BOOST, "duration": 5.0}
				var power_up = power_up_factory.create_object_with_params(spawn_pos, params)
				get_tree().current_scene.add_child(power_up)
				print("Factory: Spawned Jump Boost power-up at ", spawn_pos)
			
			KEY_4:
				# Test Factory Pattern - Spawn Shield
				var params = {"type": PowerUpFactory.PowerUpType.SHIELD, "duration": 5.0}
				var power_up = power_up_factory.create_object_with_params(spawn_pos, params)
				get_tree().current_scene.add_child(power_up)
				print("Factory: Spawned Shield power-up at ", spawn_pos)
			
			KEY_5:
				# Test Factory Pattern - Spawn Coin
				var coin = collectible_factory.create_object(spawn_pos)
				get_tree().current_scene.add_child(coin)
				print("Factory: Spawned Coin at ", spawn_pos)
			
			KEY_F1:
				# Test Strategy Pattern - Normal Movement
				if player:
					player.set_movement_strategy(NormalMovement.new())
					print("Strategy: Switched to Normal Movement (speed: 300, jump: -725)")
			
			KEY_F2:
				# Test Strategy Pattern - Powered Up Movement
				if player:
					player.set_movement_strategy(PoweredUpMovement.new())
					print("Strategy: Switched to Powered Up Movement (speed: 450, jump: -870)")
			
			KEY_F3:
				# Test Strategy Pattern - Underwater Movement
				if player:
					player.set_movement_strategy(UnderwaterMovement.new())
					print("Strategy: Switched to Underwater Movement (speed: 150, jump: -400)")
			
			KEY_P:
				# Print current power-ups (test Decorator Pattern)
				if player and player.power_up_manager:
					var count = player.power_up_manager.active_power_ups.size()
					print("Decorator: Active power-ups: ", count)
					for power_up in player.power_up_manager.active_power_ups:
						print("  - ", power_up.get_power_up_name(), " (", power_up.duration, "s remaining)")
				else:
					print("No player or PowerUpManager found")

func _process(_delta: float) -> void:
	# Display active power-ups count in console periodically
	pass
