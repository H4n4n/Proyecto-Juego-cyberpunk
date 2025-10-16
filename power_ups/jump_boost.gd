class_name JumpBoost extends PowerUp
## Jump boost power-up that increases player jump height.

const JUMP_MULTIPLIER = 1.4

func _init(p_duration: float = 5.0):
	super(p_duration)

func _on_apply() -> void:
	print("Jump Boost activated!")

func _on_remove() -> void:
	print("Jump Boost expired.")

func get_modified_jump(base_jump: float) -> float:
	return base_jump * JUMP_MULTIPLIER
