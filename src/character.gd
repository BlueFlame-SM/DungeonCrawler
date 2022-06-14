class_name Character
extends KinematicBody2D

signal character_died

const MAX_POINTS = 10
const SPEED_WEIGHT = 25
const SPEED_BIAS = 100

# health: The amount of health the player has.
# max_health: The total amount of health the player can have.
# strength: Increases attack damage.
# defence: Decreases incomming attack damage.
# speed: Increases movement speed.
# agility: (optional) Increases acceleration.
# dexterity: (optional) Increases attack speed.
export var health: int = 10 setget _set_health, _get_health
export var max_health: int = 10 setget _set_max_health, _get_max_health
export var strength: int = 1 setget _set_strength, _get_strength
export var defence: int = 1 setget _set_defence, _get_defence
export var speed: int = 1 setget _set_speed, _get_speed
export var agility: int = 1 setget _set_agility, _get_agility
export var dexterity: int = 1 setget _set_dexterity, _get_dexterity


# Computes the velocity vector of the character from `direction` and the speed stat.
func move_in_direction(direction: Vector2) -> Vector2:
	return direction.normalized() * ((speed - 1) * SPEED_WEIGHT + SPEED_BIAS)


# Kills the character.
func kill() -> void:
	_set_health(0)


# Deals `amount` damage to the character.
func damage(amount: int) -> void:
	_set_health(health - max(amount, 0))


# Heals the character by `amount` of health points.
func heal(amount: int) -> void:
	_set_health(health + max(amount, 0))


func _set_health(value: int) -> void:
	health = clamp(value, 0, max_health)
	if health == 0:
		emit_signal("character_died")


func _get_health() -> int:
	return health


func _set_max_health(value: int) -> void:
	max_health = max(value, 1)
	health = min(health, max_health)


func _get_max_health() -> int:
	return max_health


func _set_strength(value: int) -> void:
	strength = clamp(value, 1, MAX_POINTS)


func _get_strength() -> int:
	return strength


func _set_defence(value: int) -> void:
	defence = clamp(value, 1, MAX_POINTS)


func _get_defence() -> int:
	return defence


func _set_speed(value: int) -> void:
	speed = clamp(value, 1, MAX_POINTS)


func _get_speed() -> int:
	return speed


func _set_agility(value: int) -> void:
	agility = clamp(value, 1, MAX_POINTS)


func _get_agility() -> int:
	return agility


func _set_dexterity(value: int) -> void:
	dexterity = clamp(value, 1, MAX_POINTS)


func _get_dexterity() -> int:
	return dexterity
