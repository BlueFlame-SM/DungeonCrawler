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

const SPEED_WEIGHT = 5
const SPEED_BIAS = 100
const MAX_COOLDOWN = 700

export var can_move: bool = true

export var health: int = 10 setget _set_health, _get_health
export var max_health: int = 10 setget _set_max_health, _get_max_health
export var speed: int = 1 setget _set_speed, _get_speed
export var strength: int = 1 setget _set_strength, _get_strength
export var defence: int = 0 setget _set_defence, _get_defence
export var dexterity: int = 1 setget _set_dexterity, _get_dexterity
export var reach: float = 1 setget _set_reach, _get_reach

var speed_bonus: int = 0
var damage_bonus: int = 0
var defence_bonus: int = 0
var dexterity_bonus: int = 0
var reach_bonus: float = 0


func reset_stats() -> void:
	health = 10
	max_health = 10
	speed = 1
	strength = 1
	defence = 0
	dexterity = 1
	reach = 1
	speed_bonus = 0
	damage_bonus = 0
	defence_bonus = 0
	dexterity_bonus = 0
	reach_bonus = 0


func heal(amount: int) -> int:
	amount = clamp(amount, 0, max_health - health)
	health += amount
	return amount


func get_speed() -> int:
	return SPEED_BIAS + (speed + speed_bonus) * SPEED_WEIGHT


func get_damage() -> int:
	return strength + damage_bonus


func take_damage(amount: int) -> int:
	amount -= defence + defence_bonus
	amount = clamp(amount, 0, health)
	health -= amount
	return amount


func get_attack_delay() -> int:
	return int(1000 * pow(0.8, max(dexterity + dexterity_bonus - 1, 0)))


func get_reach() -> float:
	return max(reach + reach_bonus, 0)


# Computes the velocity vector of the character from `direction` and speed.
func move_in_direction(direction: Vector2) -> Vector2:
	if can_move:
		return direction.normalized() * get_speed()
	else:
		return Vector2.ZERO


func _set_health(v: int) -> void:
	v = clamp(v, 0, max_health)
	if v != health:
		var d = v - health
		health = v
		emit_signal("healthChanged", v,  d)
		if health == 0:
			emit_signal("character_died")


func _get_health() -> int:
	return health


func _set_max_health(v: int) -> void:
	max_health = max(v, 1)
	self.health = health


func _get_max_health() -> int:
	return max_health


func _set_speed(v: int) -> void:
	speed = max(v, 1)


func _get_speed() -> int:
	return speed


func _set_strength(v: int) -> void:
	strength = max(v, 1)


func _get_strength() -> int:
	return strength


func _set_defence(v: int) -> void:
	defence = max(v, 0)


func _get_defence() -> int:
	return defence


func _set_dexterity(v: int) -> void:
	dexterity = max(v, 1)


func _get_dexterity() -> int:
	return dexterity


func _set_reach(v: float) -> void:
	reach = max(v, 0)


func _get_reach() -> float:
	return reach
