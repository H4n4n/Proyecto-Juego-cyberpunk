class_name EnemyFactory extends GameObjectFactory
## Factory for creating enemy game objects.

const ENEMY_SCENE = preload("res://enemy/enemy.tscn")

func create_object(position: Vector2) -> Node2D:
	"""Create an enemy at the specified position."""
	var enemy = ENEMY_SCENE.instantiate() as Enemy
	enemy.global_position = position
	return enemy

func create_object_with_params(position: Vector2, params: Dictionary) -> Node2D:
	"""Create an enemy with custom parameters."""
	var enemy = create_object(position)
	
	# Apply custom parameters if provided
	if params.has("walk_speed"):
		enemy.set("WALK_SPEED", params["walk_speed"])
	
	return enemy

static func create() -> EnemyFactory:
	"""Static factory method to create an EnemyFactory instance."""
	return EnemyFactory.new()
