class_name ShieldPowerUp extends PowerUp
## Shield power-up that provides temporary invincibility.

func _init(p_duration: float = 5.0):
	super(p_duration)

func _on_apply() -> void:
	print("Shield activated!")

func _on_remove() -> void:
	print("Shield expired.")

func has_shield() -> bool:
	return active

func get_power_up_name() -> String:
	return "ShieldPowerUp"
