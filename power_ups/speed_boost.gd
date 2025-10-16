class_name SpeedBoost extends PowerUp
## Speed boost power-up that increases player movement speed.

const SPEED_MULTIPLIER = 1.5

func _init(p_duration: float = 5.0):
	super(p_duration)

func _on_apply() -> void:
	print("Speed Boost activated!")

func _on_remove() -> void:
	print("Speed Boost expired.")

func get_modified_speed(base_speed: float) -> float:
	return base_speed * SPEED_MULTIPLIER

func get_power_up_name() -> String:
	return "SpeedBoost"
