class_name GameObjectFactory extends RefCounted
## Abstract factory base class for creating game objects.
## Uses the Factory pattern to centralize object creation logic.

func create_object(position: Vector2) -> Node2D:
	"""
	Create and return a game object at the specified position.
	Override this method in derived factory classes.
	"""
	push_error("create_object() must be implemented by subclass")
	return null

func create_object_with_params(position: Vector2, params: Dictionary) -> Node2D:
	"""
	Create and return a game object with additional parameters.
	Override this method in derived factory classes if needed.
	"""
	return create_object(position)
