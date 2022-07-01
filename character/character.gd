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
export var temp_speed: int = 0 setget _set_temp_speed, _get_temp_speed
export var perm_damage: int = 1 setget _set_perm_damage, _get_perm_damage
export var temp_damage: int = 0 setget _set_temp_damage, _get_temp_damage
export var temp_attack_speed: int = 0 setget _set_temp_attack_speed, _get_temp_attack_speed
export var perm_attack_speed: int = 1 setget _set_perm_attack_speed, _get_perm_attack_speed
export var defence: int = 0 setget _set_defence, _get_defence
export var range_weapon: int = 1 setget _set_range_weapon, _get_range_weapon
export var can_move: bool = true

var cooldown_time: int setget , _get_cooldown_time


func move_in_direction(direction: Vector2) -> Vector2:
	"""
	Computes the velocity vector of the character from `direction` and the speed stat.
	"""
	if can_move:
		return direction.normalized() * ((perm_speed + temp_speed - 1) * SPEED_WEIGHT + SPEED_BIAS)
	else:
		return Vector2.ZERO


func kill() -> void:
	"""
	Kills the character.
	"""
	_set_health(0)


func do_damage(damage) -> void:
	"""
	Deals `amount` damage to the character.
	"""
	_set_health(health - max(damage, 0))


func _set_perm_damage(value: int) -> void:
	"""
	Sets the permanent damage of a character.
	"""
	perm_damage = clamp(value, 1, MAX_POINTS)

func _get_perm_damage() -> int:
	"""
	Returns the permanent damage of a character.
	"""
	return perm_damage

func _set_temp_damage(value: int) -> void:
	"""
	Sets the temporary damage of a character.
	"""
	temp_damage = clamp(value, 1, MAX_POINTS)

func _get_temp_damage() -> int:
	"""
	Returns the permanent damage of a character.
	"""
	return temp_damage


# Heals the character by `amount` of health points.
func heal(amount: int) -> void:
	"""
	Upgrades the health of a character.
	"""
	_set_health(health + max(amount, 0))


func _set_health(value: int) -> void:
	"""
	Sets the health of a character.
	"""
	var dif = value - health
	health = clamp(value, 0, max_health)
	if health == 0:
		emit_signal("character_died")
	emit_signal("healthChanged", health, dif)


func _get_health() -> int:
	"""
	Returns the health of a character.
	"""
	return health


func _set_max_health(value: int) -> void:
	"""
	Sets the maximum health of a character.
	"""
	max_health = max(value, 1)
	health = min(health, max_health)


func _get_max_health() -> int:
	"""
	Returns the maximum health of a character.
	"""
	return max_health


func _get_perm_speed() -> int:
	"""
	Returns the permanent speed of a character.
	"""
	return perm_speed

func _set_perm_speed(value: int) -> void:
	"""
	Sets the permanent speed of a character.
	"""
	perm_speed = clamp(value, 0, MAX_POINTS)


func _get_temp_speed() -> int:
	"""
	Returns the temporary speed of a character.
	"""
	return temp_speed

func _set_temp_speed(value: int) -> void:
	"""
	Sets the temporary speed of a character.
	"""
	temp_speed = clamp(value, 0, MAX_POINTS)


func _set_temp_attack_speed(value: int) -> void:
	"""
	Sets the temporary attack speed of a character.
	"""
	temp_attack_speed = clamp(value, 0, MAX_POINTS)


func _get_temp_attack_speed() -> int:
	"""
	Returns the temporary attack speed of a character.
	"""
	return temp_attack_speed


func _set_perm_attack_speed(value: int) -> void:
	"""
	Sets the permanent attack speed of a character.
	"""
	perm_attack_speed = clamp(value, 1, MAX_POINTS)


func _get_perm_attack_speed() -> int:
	"""
	Returns the permanent attack speed of a character.
	"""
	return perm_attack_speed


func _get_cooldown_time() -> int:
	"""
	Returns the cooldown time.
	"""
	var cooldown = max(200, MAX_COOLDOWN -  ((perm_attack_speed + temp_attack_speed) * 50))
	return cooldown


func _set_range_weapon(value: int) -> void:
	"""
	Sets the range of a character.
	"""
	range_weapon = value

func _get_range_weapon() -> int:
	"""
	Returns the range of a character.
	"""
	return range_weapon


func _set_defence(value:int) -> void:
	"""
	Sets the defence of a character.
	"""
	defence = clamp(value, 0, MAX_POINTS)


func _get_defence() -> int:
	"""
	Returns the defence of a character.
	"""
	return defence


func reset() -> void:
	"""
	Resets the stats of a character.
	"""
	health = 10
	max_health = 10
	perm_speed = 1
	temp_speed = 0
	perm_damage = 1
	temp_damage = 0
	temp_attack_speed = 0
	perm_attack_speed = 1
	range_weapon = 1
	defence = 0
	can_move = true
