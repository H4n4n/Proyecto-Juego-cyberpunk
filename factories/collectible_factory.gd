class_name CollectibleFactory extends GameObjectFactory
## Factory for creating collectible objects like coins.

const COIN_SCENE = preload("res://level/coin.tscn")

func create_object(position: Vector2) -> Node2D:
	"""Create a coin collectible at the specified position."""
	var coin = COIN_SCENE.instantiate() as Coin
	coin.global_position = position
	return coin

func create_object_with_params(position: Vector2, params: Dictionary) -> Node2D:
	"""Create a collectible with custom parameters."""
	var coin = create_object(position)
	
	# Could add custom coin values or types here in the future
	if params.has("value"):
		# Store custom value if coin script is extended to support it
		pass
	
	return coin

static func create() -> CollectibleFactory:
	"""Static factory method to create a CollectibleFactory instance."""
	return CollectibleFactory.new()
