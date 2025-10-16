class_name PowerUpFactory extends GameObjectFactory
## Factory for creating power-up collectible objects.

# Scene would need to be created, but we'll use a programmatic approach for now
const COIN_SCENE = preload("res://level/coin.tscn")  # Template for power-up visuals

enum PowerUpType {
	SPEED_BOOST,
	JUMP_BOOST,
	SHIELD
}

func create_object(position: Vector2) -> Node2D:
	"""Create a random power-up at the specified position."""
	var power_up_type = randi() % 3
	return create_power_up(position, power_up_type)

func create_object_with_params(position: Vector2, params: Dictionary) -> Node2D:
	"""Create a specific power-up with parameters."""
	var power_up_type = params.get("type", PowerUpType.SPEED_BOOST)
	var duration = params.get("duration", 5.0)
	return create_power_up(position, power_up_type, duration)

func create_power_up(position: Vector2, type: int, duration: float = 5.0) -> Node2D:
	"""Create a power-up collectible of the specified type."""
	var power_up = PowerUpCollectible.new()
	power_up.global_position = position
	power_up.power_up_type = type
	power_up.duration = duration
	
	# Add required nodes
	var sprite = Sprite2D.new()
	sprite.name = "Sprite2D"
	power_up.add_child(sprite)
	
	# Use coin texture as placeholder
	var coin = COIN_SCENE.instantiate()
	var coin_sprite = coin.get_node("Sprite2D") as Sprite2D
	if coin_sprite:
		sprite.texture = coin_sprite.texture
		sprite.hframes = coin_sprite.hframes
		sprite.vframes = coin_sprite.vframes
	coin.queue_free()
	
	var collision = CollisionShape2D.new()
	collision.name = "CollisionShape2D"
	var shape = CircleShape2D.new()
	shape.radius = 16
	collision.shape = shape
	power_up.add_child(collision)
	
	var anim_player = AnimationPlayer.new()
	anim_player.name = "AnimationPlayer"
	power_up.add_child(anim_player)
	
	# Create picked animation
	var animation = Animation.new()
	animation.length = 0.4
	
	var track_idx = animation.add_track(Animation.TYPE_VALUE)
	animation.track_set_path(track_idx, "Sprite2D:modulate")
	animation.track_insert_key(track_idx, 0.0, Color(1, 1, 1, 1))
	animation.track_insert_key(track_idx, 0.4, Color(1, 1, 1, 0))
	
	var scale_track = animation.add_track(Animation.TYPE_VALUE)
	animation.track_set_path(scale_track, "Sprite2D:scale")
	animation.track_insert_key(scale_track, 0.0, Vector2(1, 1))
	animation.track_insert_key(scale_track, 0.4, Vector2(2, 2))
	
	var call_track = animation.add_track(Animation.TYPE_METHOD)
	animation.track_set_path(call_track, ".")
	animation.track_insert_key(call_track, 0.4, {"method": "queue_free", "args": []})
	
	var library = AnimationLibrary.new()
	library.add_animation("picked", animation)
	anim_player.add_animation_library("", library)
	
	power_up.update_sprite()
	power_up.body_entered.connect(power_up._on_body_entered)
	
	return power_up

static func create() -> PowerUpFactory:
	"""Static factory method to create a PowerUpFactory instance."""
	return PowerUpFactory.new()
