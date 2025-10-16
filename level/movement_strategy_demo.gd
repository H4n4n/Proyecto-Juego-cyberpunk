extends Node
## Demo script showing how to switch between movement strategies.
## Attach this to the level or game node to test strategy switching.

@export var player_path: NodePath

var player: Player = null

func _ready():
	# Find player
	if player_path:
		player = get_node(player_path) as Player
	
	if not player:
		# Try to find player in scene
		var players = get_tree().get_nodes_in_group("players")
		if not players.is_empty():
			player = players[0] as Player
	
	if player:
		print("Movement Strategy Demo initialized")
		print("Press F1: Normal Movement")
		print("Press F2: Powered Up Movement")
		print("Press F3: Underwater Movement")
	else:
		push_warning("No player found for movement strategy demo")

func _unhandled_input(event: InputEvent) -> void:
	if not player:
		return
	
	if event is InputEventKey and event.pressed:
		match event.keycode:
			KEY_F1:
				# Switch to normal movement
				player.set_movement_strategy(NormalMovement.new())
				print("Switched to Normal Movement")
			KEY_F2:
				# Switch to powered up movement
				player.set_movement_strategy(PoweredUpMovement.new())
				print("Switched to Powered Up Movement")
			KEY_F3:
				# Switch to underwater movement
				player.set_movement_strategy(UnderwaterMovement.new())
				print("Switched to Underwater Movement")
