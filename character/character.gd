class_name Character
extends KinematicBody2D

signal character_died

const MAX_POINTS = 10
const SPEED_WEIGHT = 25
const SPEED_BIAS = 50
const MAX_COOLDOWN = 700


# health: The amount of health the player has.
# max_health: The total amount of health the player can have.
# strength: Increases attack damage.
# defence: Decreases incomming attack damage.
# speed: Increases movement speed.
# agility: (optional) Increases acceleration.
# dexterity: (optional) Increases attack speed.
export var health: int = 10 setget _set_health, _get_health
export var max_health: int = 10 setget _set_max_health, _get_max_health
export var perm_speed: int = 1 setget _set_perm_speed, _get_perm_speed
export var temp_speed: int = 1 setget _set_temp_speed, _get_temp_speed
export var perm_damage: int = 1 setget _set_perm_damage, _get_perm_damage
export var temp_damage: int = 1 setget _set_temp_damage, _get_temp_damage
export var attack_speed: int = 1 setget _set_attack_speed, _get_attack_speed
export var cooldown_time: int = 1000 setget _set_cooldown_time, _get_cooldown_time
export var range_weapon: int = 1 setget _set_range_weapon, _get_range_weapon

export var can_move: bool = true
signal healthChanged(newValue, dif)


# Computes the velocity vector of the character from `direction` and the speed stat.
func move_in_direction(direction: Vector2) -> Vector2:
	if can_move:
		return direction.normalized() * ((temp_speed - 1) * SPEED_WEIGHT + SPEED_BIAS)
	else:
		return Vector2.ZERO


# Kills the character.
func kill() -> void:
	_set_health(0)


# Deals `amount` damage to the character.
func do_damage(damage) -> void:
	_set_health(health - max(damage, 0))


func _set_perm_damage(value: int) -> void:
	perm_damage = clamp(perm_damage + value, 1, MAX_POINTS)
	temp_damage = _get_temp_damage() + value

func _get_perm_damage() -> int:
	return perm_damage

func _set_temp_damage(value: int) -> void:
	temp_damage = clamp(perm_damage + value, 1, MAX_POINTS)

func _get_temp_damage() -> int:
	return temp_damage


# Heals the character by `amount` of health points.
func heal(amount: int) -> void:
	_set_health(health + max(amount, 0))


func _set_health(value: int) -> void:
	var dif = value - health
	health = clamp(value, 0, max_health)
	if health == 0:
		emit_signal("character_died")
	emit_signal("healthChanged", health, dif)


func _get_health() -> int:
	return health


func _set_max_health(value: int) -> void:
	max_health = max(value, 1)
	health = min(health, max_health)


func _get_max_health() -> int:
	return max_health


func _get_perm_speed() -> int:
	return perm_speed

func _set_perm_speed(value: int) -> void:
	perm_speed = clamp(value + perm_speed, 1, MAX_POINTS)
	temp_speed = _get_temp_speed() + value


func _get_temp_speed() -> int:
	return temp_speed

func _set_temp_speed(value: int) -> void:
	temp_speed = clamp(value + perm_speed, 1, MAX_POINTS)

func _get_attack_speed() -> int:
	return attack_speed

func _set_attack_speed(value: int) -> void:
	_set_cooldown_time(MAX_COOLDOWN - (value * 100)) #


func _set_cooldown_time(value: int) -> void:
	cooldown_time = clamp(value, 100, MAX_COOLDOWN) #?????

func _get_cooldown_time() -> int:
	return cooldown_time

func _set_range_weapon(value: int) -> void:
	range_weapon = value

func _get_range_weapon() -> int:
	return range_weapon
