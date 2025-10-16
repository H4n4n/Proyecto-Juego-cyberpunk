class_name PowerUpCollectible extends Area2D
## Collectible power-up item that can be picked up by the player.

enum PowerUpType {
	SPEED_BOOST,
	JUMP_BOOST,
	SHIELD
}

@export var power_up_type: PowerUpType = PowerUpType.SPEED_BOOST
@export var duration: float = 5.0

@onready var animation_player := $AnimationPlayer as AnimationPlayer
@onready var sprite := $Sprite2D as Sprite2D

func _ready():
	# Set sprite based on power-up type
	update_sprite()

func update_sprite() -> void:
	"""Update the sprite appearance based on power-up type."""
	if not sprite:
		return
	
	# Set different colors/modulation for different power-ups
	match power_up_type:
		PowerUpType.SPEED_BOOST:
			sprite.modulate = Color(0.2, 1.0, 0.2)  # Green
		PowerUpType.JUMP_BOOST:
			sprite.modulate = Color(1.0, 0.5, 0.2)  # Orange
		PowerUpType.SHIELD:
			sprite.modulate = Color(0.2, 0.5, 1.0)  # Blue

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		collect(body as Player)

func collect(player: Player) -> void:
	"""Apply the power-up to the player and remove the collectible."""
	var power_up: PowerUp
	
	match power_up_type:
		PowerUpType.SPEED_BOOST:
			power_up = SpeedBoost.new(duration)
		PowerUpType.JUMP_BOOST:
			power_up = JumpBoost.new(duration)
		PowerUpType.SHIELD:
			power_up = ShieldPowerUp.new(duration)
	
	if player.power_up_manager:
		player.power_up_manager.add_power_up(power_up)
	
	# Play pickup animation and remove
	if animation_player:
		animation_player.play(&"picked")
	else:
		queue_free()
