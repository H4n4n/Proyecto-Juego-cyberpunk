class_name PowerUpManager extends Node
## Manages active power-ups on the player, handling application and expiration.

var active_power_ups: Array[PowerUp] = []
var player: Player = null

func _init(p_player: Player):
	player = p_player

func _process(delta: float) -> void:
	# Update power-up timers
	var expired_power_ups: Array[PowerUp] = []
	for power_up in active_power_ups:
		power_up.duration -= delta
		if power_up.duration <= 0:
			expired_power_ups.append(power_up)
	
	# Remove expired power-ups
	for power_up in expired_power_ups:
		remove_power_up(power_up)

func add_power_up(power_up: PowerUp) -> void:
	"""Add and apply a power-up to the player."""
	power_up.apply(player)
	active_power_ups.append(power_up)

func remove_power_up(power_up: PowerUp) -> void:
	"""Remove a power-up from the player."""
	power_up.remove()
	active_power_ups.erase(power_up)

func get_modified_speed(base_speed: float) -> float:
	"""Get the speed modified by all active power-ups."""
	var speed = base_speed
	for power_up in active_power_ups:
		speed = power_up.get_modified_speed(speed)
	return speed

func get_modified_jump(base_jump: float) -> float:
	"""Get the jump velocity modified by all active power-ups."""
	var jump = base_jump
	for power_up in active_power_ups:
		jump = power_up.get_modified_jump(jump)
	return jump

func has_shield() -> bool:
	"""Check if any active power-up provides a shield."""
	for power_up in active_power_ups:
		if power_up.has_shield():
			return true
	return false

func clear_all() -> void:
	"""Remove all active power-ups."""
	for power_up in active_power_ups:
		power_up.remove()
	active_power_ups.clear()
