class_name StatusSystem
extends Node

signal health_depleted

export var health: int = 50 setget _set_health, _get_health
export var max_health: int = 50 setget _set_max_health, _get_max_health
export var speed: float = 400 setget _set_speed, _get_speed
export var strength: int = 25 setget _set_strength, _get_strength
export var defence: int = 25 setget _set_defence, _get_defence



func _set_health(value):
	health = clamp(value, 0, max_health)
	if health == 0:
		emit_signal("health_depleted")


func _get_health():
	return health


func _set_max_health(value):
	max_health = max(value, 1)
	health = min(health, max_health)


func _get_max_health():
	return max_health


func _set_speed(value):
	speed = max(value, 0)


func _get_speed():
	return speed


func _set_strength(value):
	strength = min(value, 0)


func _get_strength():
	return strength


func _set_defence(value):
	defence = min(value, 0)


func _get_defence():
	return defence
