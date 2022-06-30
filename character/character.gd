class_name Character
extends KinematicBody2D
"""
An entity in the world with stats, which can move, take and deal damage.

Attributes:
	health: The current amount of health, between 0 and `max_health`.
	max_health: The maximum amount of health with a minimum value of 1.
	perm_speed: A permanent boost to speed, between 0 and `MAX_POINTS`.
	temp_speed: A temporary boost to speed, between 0 and `MAX_POINTS`.
	perm_damage: A permanent boost to damage, between 0 and `MAX_POINTS`.
	temp_damage: A temporary boost to damage, between 0 and `MAX_POINTS`.
	attack_speed: The current attack speed, between 1 and `MAX_POINTS`.
	range_weapon: The attack range.
	can_move: True if the character can move.
	cooldown_time: The cooldown time between attacks.
"""

signal character_died
signal healthChanged(newValue, dif)

const MAX_POINTS = 10
const SPEED_WEIGHT = 25
const SPEED_BIAS = 50
const MAX_COOLDOWN = 700

export var health: int = 10 setget _set_health, _get_health
export var max_health: int = 10 setget _set_max_health, _get_max_health
export var perm_speed: int = 1 setget _set_perm_speed, _get_perm_speed
export var temp_speed: int = 1 setget _set_temp_speed, _get_temp_speed
export var perm_damage: int = 1 setget _set_perm_damage, _get_perm_damage
export var temp_damage: int = 1 setget _set_temp_damage, _get_temp_damage
export var temp_attack_speed: int = 1 setget _set_temp_attack_speed, _get_temp_attack_speed
export var perm_attack_speed: int = 1 setget _set_perm_attack_speed, _get_perm_attack_speed
export var range_weapon: int = 1 setget _set_range_weapon, _get_range_weapon
export var can_move: bool = true

var cooldown_time: int setget , _get_cooldown_time


# Computes the velocity vector of the character from `direction` and the speed stat.
func move_in_direction(direction: Vector2) -> Vector2:
	if can_move:
		return direction.normalized() * ((perm_speed + temp_speed - 1) * SPEED_WEIGHT + SPEED_BIAS)
	else:
		return Vector2.ZERO


# Kills the character.
func kill() -> void:
	_set_health(0)


# Deals `amount` damage to the character.
func do_damage(damage) -> void:
	_set_health(health - max(damage, 0))


func _set_perm_damage(value: int) -> void:
	perm_damage = clamp(value, 1, MAX_POINTS)

func _get_perm_damage() -> int:
	return perm_damage

func _set_temp_damage(value: int) -> void:
	temp_damage = clamp(value, 1, MAX_POINTS)

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
	perm_speed = clamp(value, 0, MAX_POINTS)


func _get_temp_speed() -> int:
	return temp_speed

func _set_temp_speed(value: int) -> void:
	temp_speed = clamp(value, 0, MAX_POINTS)


func _set_temp_attack_speed(value: int) -> void:
	temp_attack_speed = clamp(value, 0, MAX_POINTS)


func _get_temp_attack_speed() -> int:
	return temp_attack_speed


func _set_perm_attack_speed(value: int) -> void:
	perm_attack_speed = clamp(value, 1, MAX_POINTS)


func _get_perm_attack_speed() -> int:
	return perm_attack_speed


func _get_cooldown_time() -> int:
	var cooldown = MAX_COOLDOWN * (1 - (perm_attack_speed + temp_attack_speed - 1) / (2 * MAX_POINTS))
	return cooldown


func _set_range_weapon(value: int) -> void:
	range_weapon = value

func _get_range_weapon() -> int:
	return range_weapon
