# Design Patterns and Parallax System Documentation

This document describes the design patterns and enhanced parallax scrolling system implemented in the game.

## Overview

The game now includes three major design patterns and an enhanced parallax scrolling system:

1. **Decorator Pattern** - For power-ups
2. **Factory Pattern** - For game object creation
3. **Strategy Pattern** - For player movement
4. **Enhanced Parallax Scrolling** - For improved visual effects

---

## 1. Decorator Pattern (Power-ups)

### Purpose
The Decorator pattern allows power-ups to modify player abilities dynamically without changing the Player class structure.

### Location
- `power_ups/` directory

### Key Classes

#### `PowerUp` (Base Class)
The abstract decorator base class for all power-ups.
- **File**: `power_ups/power_up.gd`
- **Methods**:
  - `apply(player: Player)` - Apply the power-up to the player
  - `remove()` - Remove the power-up effect
  - `get_modified_speed(base_speed)` - Modify player speed
  - `get_modified_jump(base_jump)` - Modify player jump
  - `has_shield()` - Check if power-up provides shield

#### Concrete Power-ups

1. **`SpeedBoost`** (`power_ups/speed_boost.gd`)
   - Increases movement speed by 50%
   - Default duration: 5 seconds

2. **`JumpBoost`** (`power_ups/jump_boost.gd`)
   - Increases jump height by 40%
   - Default duration: 5 seconds

3. **`ShieldPowerUp`** (`power_ups/shield_power_up.gd`)
   - Provides temporary invincibility
   - Default duration: 5 seconds

#### `PowerUpManager`
Manages all active power-ups on the player.
- **File**: `power_ups/power_up_manager.gd`
- **Methods**:
  - `add_power_up(power_up)` - Add a new power-up
  - `remove_power_up(power_up)` - Remove a specific power-up
  - `get_modified_speed(base_speed)` - Get speed with all power-up modifiers
  - `get_modified_jump(base_jump)` - Get jump with all power-up modifiers
  - `has_shield()` - Check if player has any shield
  - `clear_all()` - Remove all power-ups

#### `PowerUpCollectible`
In-game collectible item that applies power-ups when picked up.
- **File**: `power_ups/power_up_collectible.gd`
- **Properties**:
  - `power_up_type` - Type of power-up (SPEED_BOOST, JUMP_BOOST, SHIELD)
  - `duration` - How long the power-up lasts

### Usage Example

```gdscript
# Programmatically add a power-up to the player
var speed_boost = SpeedBoost.new(5.0)  # 5 second duration
player.power_up_manager.add_power_up(speed_boost)

# Or use the collectible in the scene
# The PowerUpCollectible will automatically apply when player touches it
```

---

## 2. Factory Pattern (Game Objects)

### Purpose
The Factory pattern centralizes object creation logic and provides a consistent interface for spawning game entities.

### Location
- `factories/` directory

### Key Classes

#### `GameObjectFactory` (Abstract Base)
Abstract factory base class for all game object factories.
- **File**: `factories/game_object_factory.gd`
- **Methods**:
  - `create_object(position)` - Create an object at position
  - `create_object_with_params(position, params)` - Create with custom parameters

#### Concrete Factories

1. **`EnemyFactory`** (`factories/enemy_factory.gd`)
   - Creates enemy instances
   - Supports custom walk speed parameter
   - Static method: `EnemyFactory.create()`

2. **`PowerUpFactory`** (`factories/power_up_factory.gd`)
   - Creates power-up collectibles
   - Supports all three power-up types
   - Programmatically builds complete collectible nodes
   - Static method: `PowerUpFactory.create()`

3. **`CollectibleFactory`** (`factories/collectible_factory.gd`)
   - Creates coin collectibles
   - Can be extended for other collectible types
   - Static method: `CollectibleFactory.create()`

### Usage Example

```gdscript
# Initialize factories
var enemy_factory = EnemyFactory.create()
var power_up_factory = PowerUpFactory.create()
var collectible_factory = CollectibleFactory.create()

# Spawn an enemy
var enemy = enemy_factory.create_object(Vector2(100, 200))
add_child(enemy)

# Spawn a power-up with custom parameters
var params = {"type": PowerUpFactory.PowerUpType.SPEED_BOOST, "duration": 10.0}
var power_up = power_up_factory.create_object_with_params(Vector2(300, 200), params)
add_child(power_up)

# Spawn a coin
var coin = collectible_factory.create_object(Vector2(500, 200))
add_child(coin)
```

### Demo Script
A demonstration script is provided at `level/factory_spawner_demo.gd` that shows factory usage:
- Press **1** to spawn an enemy at mouse position
- Press **2** to spawn a speed boost power-up
- Press **3** to spawn a jump boost power-up
- Press **4** to spawn a shield power-up
- Press **5** to spawn a coin

---

## 3. Strategy Pattern (Movement)

### Purpose
The Strategy pattern allows dynamic switching between different movement behaviors without modifying the Player class.

### Location
- `movement_strategies/` directory

### Key Classes

#### `MovementStrategy` (Base Class)
Abstract strategy base class for movement behaviors.
- **File**: `movement_strategies/movement_strategy.gd`
- **Methods**:
  - `get_walk_speed()` - Return walk speed
  - `get_acceleration()` - Return acceleration
  - `get_jump_velocity()` - Return jump velocity
  - `get_gravity_multiplier()` - Return gravity modifier
  - `apply_movement_modifiers(player, delta)` - Apply special modifiers
  - `get_strategy_name()` - Return strategy name

#### Concrete Strategies

1. **`NormalMovement`** (`movement_strategies/normal_movement.gd`)
   - Standard player movement
   - Walk speed: 300
   - Jump velocity: -725
   - Gravity multiplier: 1.0

2. **`PoweredUpMovement`** (`movement_strategies/powered_up_movement.gd`)
   - Enhanced movement for powered-up state
   - Walk speed: 450 (50% faster)
   - Jump velocity: -870 (20% higher)
   - Gravity multiplier: 0.9 (floatier)

3. **`UnderwaterMovement`** (`movement_strategies/underwater_movement.gd`)
   - Slower movement for underwater areas
   - Walk speed: 150 (50% slower)
   - Jump velocity: -400 (much lower)
   - Gravity multiplier: 0.3 (buoyancy effect)
   - Applies water resistance to horizontal movement

### Player Integration

The Player class now includes:
- `movement_strategy` property - Current active strategy
- `set_movement_strategy(strategy)` - Method to change strategy
- Movement physics use strategy values instead of constants

### Usage Example

```gdscript
# Get player reference
var player = $Player

# Switch to underwater movement
player.set_movement_strategy(UnderwaterMovement.new())

# Switch back to normal
player.set_movement_strategy(NormalMovement.new())

# Use powered up movement
player.set_movement_strategy(PoweredUpMovement.new())
```

### Demo Script
A demonstration script is provided at `level/movement_strategy_demo.gd`:
- Press **F1** to switch to Normal Movement
- Press **F2** to switch to Powered Up Movement
- Press **F3** to switch to Underwater Movement

---

## 4. Enhanced Parallax Scrolling

### Purpose
Provides an enhanced parallax background system with camera-tied scrolling and dynamic layer management.

### Location
- `level/background/parallax_controller.gd`

### Key Class: `ParallaxController`

Extends `ParallaxBackground` with enhanced features.

#### Properties
- `enable_auto_scroll` - Enable automatic scrolling
- `auto_scroll_speed` - Speed of auto-scroll (Vector2)
- `camera_influence` - How much camera affects parallax (0-1)

#### Methods
- `set_layer_speed(layer_name, motion_scale)` - Change layer scroll speed
- `add_parallax_layer(layer_name, texture, motion_scale, offset)` - Add new layer dynamically
- `get_layer_count()` - Get number of parallax layers

### Features

1. **Camera-Tied Scrolling**
   - Parallax automatically follows camera movement
   - Adjustable influence factor

2. **Auto-Scroll**
   - Optional automatic scrolling
   - Configurable speed and direction

3. **Dynamic Layer Management**
   - Add/modify layers at runtime
   - Change scroll speeds dynamically

4. **Automatic Camera Detection**
   - Finds player camera automatically
   - Falls back to scene camera if needed

### Usage Example

```gdscript
# In your level scene, replace ParallaxBackground with ParallaxController
var parallax = ParallaxController.new()
add_child(parallax)

# Configure auto-scroll
parallax.enable_auto_scroll = true
parallax.auto_scroll_speed = Vector2(20, 0)

# Adjust camera influence
parallax.camera_influence = 1.0

# Add a new layer dynamically
var texture = preload("res://path/to/texture.png")
parallax.add_parallax_layer("NewLayer", texture, Vector2(0.3, 1.0))

# Change existing layer speed
parallax.set_layer_speed("Mountains1", Vector2(0.5, 1.0))
```

### Existing Parallax Structure

The existing parallax background (`level/background/parallax_background.tscn`) has these layers:
1. **Sky** - Motion scale: (0.2, 1) - Slowest
2. **BaseColor** - Fixed background
3. **Clouds** - Motion scale: (0.1, 1) - Very slow
4. **Mountains2** - Motion scale: (0.2, 1) - Slow
5. **Mountains1** - Motion scale: (0.4, 1) - Medium

To use `ParallaxController`, you can:
1. Change the script of the existing ParallaxBackground node to `ParallaxController`
2. Or create a new ParallaxController and copy the layers

---

## Integration Points

### Player Integration
The Player class has been updated with:
```gdscript
# Design pattern properties
var power_up_manager: PowerUpManager = null
var movement_strategy: MovementStrategy = null

# Initialization in _ready()
power_up_manager = PowerUpManager.new(self)
add_child(power_up_manager)
movement_strategy = NormalMovement.new()

# Movement applies strategy and power-up modifiers
var walk_speed = movement_strategy.get_walk_speed()
walk_speed = power_up_manager.get_modified_speed(walk_speed)
```

### Level Integration
To fully integrate these systems into your levels:

1. **Add Factory Spawner** (Optional)
   - Attach `factory_spawner_demo.gd` to a node in your level
   - Use it to test spawning or implement your own spawner logic

2. **Add Movement Strategy Demo** (Optional)
   - Attach `movement_strategy_demo.gd` to test strategy switching
   - Set `player_path` to point to your player node

3. **Update Parallax Background** (Optional)
   - Replace ParallaxBackground with ParallaxController in your level
   - Configure auto-scroll and camera influence as desired

---

## Benefits

### Code Organization
- Clear separation of concerns
- Each pattern addresses a specific problem
- Easy to extend with new power-ups, objects, or strategies

### Flexibility
- Add new power-ups without modifying Player class
- Create new game objects through factories
- Switch movement behavior dynamically
- Modify parallax layers at runtime

### Maintainability
- Centralized object creation logic
- Power-ups are self-contained
- Movement strategies are independent
- Easy to test individual components

### Extensibility
- New power-up types: Extend `PowerUp`
- New factories: Extend `GameObjectFactory`
- New movement modes: Extend `MovementStrategy`
- New parallax layers: Use `add_parallax_layer()`

---

## Future Enhancements

Possible extensions to these systems:

1. **Power-ups**
   - Visual effects for active power-ups
   - Power-up stacking logic
   - Power-up indicators in UI

2. **Factories**
   - Object pooling for performance
   - Spawn patterns (waves, formations)
   - Difficulty-based parameters

3. **Movement Strategies**
   - Transition animations between strategies
   - Hybrid strategies
   - Context-based auto-switching

4. **Parallax**
   - Weather effects layers
   - Dynamic time-of-day lighting
   - Parallax-based fog and atmosphere

---

## Testing

### Manual Testing Checklist

- [ ] Power-ups can be collected and applied
- [ ] Power-up effects are visible (speed, jump changes)
- [ ] Power-ups expire after duration
- [ ] Multiple power-ups can be active simultaneously
- [ ] Factories spawn objects at correct positions
- [ ] Factory-spawned objects behave correctly
- [ ] Movement strategies change player behavior
- [ ] Strategy switching works at runtime
- [ ] Parallax follows camera movement
- [ ] Existing game functionality still works

### Test Commands

Run the game and use these inputs to test:

**Factory Pattern:**
- Keys 1-5: Spawn different objects

**Movement Strategy:**
- F1/F2/F3: Switch strategies

**Power-ups:**
- Collect spawned power-ups to test effects

---

## Conclusion

These design patterns enhance the game architecture by providing:
- **Flexibility** in extending game features
- **Maintainability** through better code organization
- **Reusability** of common patterns
- **Testability** of individual components

All patterns maintain the existing game functionality while adding new capabilities in a modular, non-intrusive way.
