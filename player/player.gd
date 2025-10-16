class_name Player extends CharacterBody2D

signal coin_collected()

const WALK_SPEED = 300.0
const ACCELERATION_SPEED = WALK_SPEED * 6.0
const JUMP_VELOCITY = -725.0
const TERMINAL_VELOCITY = 700

# --- DESIGN PATTERNS ---
var power_up_manager: PowerUpManager = null
var movement_strategy: MovementStrategy = null

# --- DASH CONSTANTS ---
const DASH_SPEED = 800.0
const DASH_TIME = 0.15 # seconds
const DASH_COOLDOWN = 0.5 # seconds

# --- GRAPPLING HOOK CONSTANTS ---
const GRAPPLE_SPEED = 1300.0
const GRAPPLE_MAX_DISTANCE = 350.0
const GRAPPLE_PULL_FORCE = 2200.0
const GRAPPLE_MIN_DISTANCE = 16.0

@export var action_suffix := ""

var gravity: int = ProjectSettings.get("physics/2d/default_gravity")
@onready var platform_detector := $PlatformDetector as RayCast2D
@onready var animation_player := $AnimationPlayer as AnimationPlayer
@onready var shoot_timer := $ShootAnimation as Timer
@onready var sprite := $Sprite2D as Sprite2D
@onready var jump_sound := $Jump as AudioStreamPlayer2D
@onready var gun = sprite.get_node(^"Gun") as Gun
@onready var camera := $Camera as Camera2D
@onready var grapple_line := $GrappleLine as Line2D

var _double_jump_charged := false

# --- DASH STATE ---
var is_dashing := false
var dash_timer := 0.0
var dash_cooldown_timer := 0.0
var dash_direction := 1

# --- GRAPPLING HOOK STATE ---
var is_grappling := false
var grapple_point := Vector2.ZERO
var grapple_attached := false

# --- SHOOTING STATE ---
var is_shooting := false

func _ready():
	if grapple_line:
		grapple_line.visible = false  # Hide line at start
	
	# Initialize design patterns
	power_up_manager = PowerUpManager.new(self)
	add_child(power_up_manager)
	movement_strategy = NormalMovement.new()
	
	# Add player to group for easy finding
	add_to_group("players")

func _physics_process(delta: float) -> void:
	# --- DASH INPUT ---
	if not is_dashing and dash_cooldown_timer <= 0.0 and not is_grappling:
		if Input.is_action_just_pressed("dash" + action_suffix):
			is_dashing = true
			dash_timer = DASH_TIME
			dash_cooldown_timer = DASH_COOLDOWN
			if not is_zero_approx(velocity.x):
				dash_direction = sign(velocity.x)
			else:
				dash_direction = sign(sprite.scale.x)
	
	# --- GRAPPLE INPUT ---
	if Input.is_action_just_pressed("grapple" + action_suffix) and not is_grappling and not is_dashing:
		var start = global_position
		var end = get_global_mouse_position()
		var direction = (end - start).normalized()
		var space_state = get_world_2d().direct_space_state
		var query = PhysicsRayQueryParameters2D.new()
		query.from = start
		query.to = start + direction * GRAPPLE_MAX_DISTANCE
		query.exclude = [self]
		var result = space_state.intersect_ray(query)
		if result:
			print("Grapple hit at: ", result.position)
			is_grappling = true
			grapple_point = result.position
			grapple_attached = true
			if grapple_line:
				print("Setting GrappleLine points:", global_position, grapple_point)
				grapple_line.visible = true
				# --- FIX: Use local coordinates for points
				grapple_line.points = [Vector2.ZERO, grapple_point - global_position]
		else:
			print("Grapple missed")
			is_grappling = false
			grapple_attached = false
			if grapple_line:
				grapple_line.visible = false

	# --- GRAPPLE RELEASE ---
	if is_grappling and Input.is_action_just_released("grapple" + action_suffix):
		is_grappling = false
		grapple_attached = false
		if grapple_line:
			grapple_line.visible = false

	# --- GRAPPLE PHYSICS ---
	if is_grappling and grapple_attached:
		var to_grapple = grapple_point - global_position
		if to_grapple.length() > GRAPPLE_MIN_DISTANCE:
			var pull = to_grapple.normalized() * GRAPPLE_PULL_FORCE * delta
			velocity += pull
		else:
			# Reached the grapple point
			is_grappling = false
			grapple_attached = false
			if grapple_line:
				grapple_line.visible = false

		# Update grapple line (always use local coordinates)
		if grapple_line:
			print("Updating GrappleLine points:", global_position, grapple_point)
			grapple_line.points = [Vector2.ZERO, grapple_point - global_position]

	# --- DASH LOGIC ---
	if is_dashing:
		velocity.x = DASH_SPEED * dash_direction
		velocity.y = 0 # Optional: cancel vertical motion during dash
		dash_timer -= delta
		if dash_timer <= 0.0:
			is_dashing = false
	elif not is_grappling:
		# --- NORMAL MOVEMENT ---
		if is_on_floor():
			_double_jump_charged = true
		if Input.is_action_just_pressed("jump" + action_suffix):
			try_jump()
		elif Input.is_action_just_released("jump" + action_suffix) and velocity.y < 0.0:
			velocity.y *= 0.6
		
		# Apply movement strategy and power-up modifiers
		var effective_gravity = gravity
		if movement_strategy:
			effective_gravity *= movement_strategy.get_gravity_multiplier()
			movement_strategy.apply_movement_modifiers(self, delta)
		
		velocity.y = minf(TERMINAL_VELOCITY, velocity.y + effective_gravity * delta)
		
		# Get movement speed from strategy and power-ups
		var walk_speed = WALK_SPEED
		if movement_strategy:
			walk_speed = movement_strategy.get_walk_speed()
		if power_up_manager:
			walk_speed = power_up_manager.get_modified_speed(walk_speed)
		
		var direction := Input.get_axis("move_left" + action_suffix, "move_right" + action_suffix) * walk_speed
		var acceleration = walk_speed * 6.0
		velocity.x = move_toward(velocity.x, direction, acceleration * delta)
		if not is_zero_approx(velocity.x):
			if velocity.x > 0.0:
				sprite.scale.x = 1.0
			else:
				sprite.scale.x = -1.0

	floor_stop_on_slope = not platform_detector.is_colliding()
	move_and_slide()

	# --- DASH COOLDOWN TIMER ---
	if dash_cooldown_timer > 0.0:
		dash_cooldown_timer -= delta

	# --- SHOOTING (blocked during dash or grapple) ---
	is_shooting = false
	if not is_dashing and not is_grappling and Input.is_action_just_pressed("shoot" + action_suffix):
		is_shooting = gun.shoot(sprite.scale.x)

	# --- ANIMATION ---
	var animation := get_new_animation(is_shooting)
	if animation != animation_player.current_animation and shoot_timer.is_stopped():
		if is_shooting:
			shoot_timer.start()
		animation_player.play(animation)

func get_new_animation(is_shooting := false) -> String:
	var animation_new: String
	if is_on_floor():
		if absf(velocity.x) > 0.1:
			animation_new = "run"
		else:
			animation_new = "idle"
	else:
		if velocity.y > 0.0:
			animation_new = "falling"
		else:
			animation_new = "jumping"
	if is_shooting:
		animation_new += "_weapon"
	if is_dashing:
		animation_new = "run" # Or use a "dash" animation if you have one!
	if is_grappling:
		animation_new = "jumping" # Or use a "grappling" animation if you have one!
	return animation_new

func try_jump() -> void:
	# Get jump velocity from strategy and power-ups
	var jump_velocity = JUMP_VELOCITY
	if movement_strategy:
		jump_velocity = movement_strategy.get_jump_velocity()
	if power_up_manager:
		jump_velocity = power_up_manager.get_modified_jump(jump_velocity)
	
	if is_on_floor():
		jump_sound.pitch_scale = 1.0
	elif _double_jump_charged:
		_double_jump_charged = false
		velocity.x *= 2.5
		jump_sound.pitch_scale = 1.5
	else:
		return
	velocity.y = jump_velocity
	jump_sound.play()

func set_movement_strategy(strategy: MovementStrategy) -> void:
	"""Change the player's movement strategy."""
	movement_strategy = strategy
	print("Movement strategy changed to: ", strategy.get_strategy_name())
