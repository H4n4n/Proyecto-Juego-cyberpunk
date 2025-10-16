# Quick Start Guide - Design Patterns

This guide helps you quickly integrate and use the new design patterns in your game.

## Quick Integration Checklist

### ✅ Already Done (No Action Needed)
- Player has PowerUpManager initialized
- Player has MovementStrategy set to NormalMovement
- All pattern classes are created and ready to use

### 🎮 To Test in Godot

1. **Open the project in Godot 4.4+**

2. **Add demo script to test all patterns:**
   - Open `level.tscn` or your main scene
   - Add a new Node to the scene
   - Attach `level/design_patterns_demo.gd` script to it
   - Run the game and use these keys:
     - `1-5`: Spawn objects (Factory Pattern)
     - `F1-F3`: Change movement (Strategy Pattern)
     - Collect power-ups to test Decorator Pattern

### 📝 Using Patterns in Your Code

#### 1. Decorator Pattern (Power-ups)

```gdscript
# To add a power-up to the player programmatically:
var speed_boost = SpeedBoost.new(5.0)  # 5 seconds duration
player.power_up_manager.add_power_up(speed_boost)

# Or spawn a collectible power-up:
var factory = PowerUpFactory.create()
var params = {"type": PowerUpFactory.PowerUpType.SPEED_BOOST, "duration": 10.0}
var power_up = factory.create_object_with_params(Vector2(100, 100), params)
add_child(power_up)
```

#### 2. Factory Pattern (Object Creation)

```gdscript
# Initialize factories (do this once):
var enemy_factory = EnemyFactory.create()
var power_up_factory = PowerUpFactory.create()
var collectible_factory = CollectibleFactory.create()

# Spawn enemies:
var enemy = enemy_factory.create_object(Vector2(200, 300))
add_child(enemy)

# Spawn coins:
var coin = collectible_factory.create_object(Vector2(400, 200))
add_child(coin)
```

#### 3. Strategy Pattern (Movement)

```gdscript
# Change player movement behavior:
player.set_movement_strategy(NormalMovement.new())      # Normal
player.set_movement_strategy(PoweredUpMovement.new())   # Fast & high jumps
player.set_movement_strategy(UnderwaterMovement.new())  # Slow & floaty

# Example: Change to underwater when entering water area
func _on_water_area_entered(body):
    if body is Player:
        body.set_movement_strategy(UnderwaterMovement.new())

func _on_water_area_exited(body):
    if body is Player:
        body.set_movement_strategy(NormalMovement.new())
```

## Common Use Cases

### Use Case 1: Power-up on Enemy Death
```gdscript
# In enemy.gd destroy() function:
func destroy() -> void:
    _state = State.DEAD
    velocity = Vector2.ZERO
    
    # Spawn a power-up at enemy position
    var factory = PowerUpFactory.create()
    var power_up = factory.create_object(global_position)
    get_parent().add_child(power_up)
```

### Use Case 2: Wave Spawner with Factory
```gdscript
# Create an enemy wave spawner:
class_name WaveSpawner extends Node2D

var enemy_factory: EnemyFactory

func _ready():
    enemy_factory = EnemyFactory.create()

func spawn_wave(enemy_count: int):
    for i in enemy_count:
        var pos = Vector2(randf_range(0, 800), 300)
        var enemy = enemy_factory.create_object(pos)
        get_parent().add_child(enemy)
```

### Use Case 3: Special Areas with Movement Changes
```gdscript
# Area that changes movement strategy:
extends Area2D

@export var movement_type: String = "normal"  # "normal", "powered", "underwater"

func _on_body_entered(body):
    if body is Player:
        match movement_type:
            "normal":
                body.set_movement_strategy(NormalMovement.new())
            "powered":
                body.set_movement_strategy(PoweredUpMovement.new())
            "underwater":
                body.set_movement_strategy(UnderwaterMovement.new())
```

## Testing Your Implementation

### Step 1: Verify Player Initialization
```gdscript
# Add to player _ready() for debugging:
print("PowerUpManager: ", power_up_manager != null)
print("MovementStrategy: ", movement_strategy.get_strategy_name())
```

### Step 2: Test Power-up Collection
- Spawn a power-up using demo script (key 2, 3, or 4)
- Move player to collect it
- Check console for "Power-up activated!" message
- Notice speed or jump changes

### Step 3: Test Movement Strategies
- Press F1, F2, F3 to switch strategies
- Move and jump to feel the difference
- Check console for strategy change messages

### Step 4: Test Factories
- Press 1-5 to spawn different objects
- Verify they appear and behave correctly

## Troubleshooting

### Power-ups not working?
- Check that player has `power_up_manager` initialized
- Verify power-up collectible has Area2D collision shape
- Check console for error messages

### Movement strategy not changing?
- Verify player has `movement_strategy` property
- Check that _physics_process uses strategy values
- Look for console messages when pressing F1-F3

### Factory objects not spawning?
- Check the scene is added as child to the correct node
- Verify preload paths are correct (res://...)
- Check for console errors about missing scenes

## Next Steps

1. **Extend Patterns:**
   - Create new power-ups (e.g., `InvisibilityPowerUp`)
   - Add new factories (e.g., `ObstacleFactory`)
   - Design new strategies (e.g., `IceMovement`)

2. **Polish:**
   - Add visual effects for power-ups
   - Create UI indicators for active power-ups
   - Add sound effects for strategy changes

3. **Level Design:**
   - Place power-ups strategically in levels
   - Create areas that auto-switch movement strategy
   - Use factories for procedural content

## Additional Resources

- Full documentation: `DESIGN_PATTERNS.md`
- Example scripts:
  - `level/design_patterns_demo.gd`
  - `level/factory_spawner_demo.gd`
  - `level/movement_strategy_demo.gd`

## Support

If you encounter issues:
1. Check the console for error messages
2. Review the documentation in `DESIGN_PATTERNS.md`
3. Examine the demo scripts for usage examples
4. Verify Godot version is 4.4 or higher
