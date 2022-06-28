extends Node

var level_type = "start"

var level_counter = 0

signal challenge_down(type, pos)

func challenge_down(type, pos=Vector2.ZERO):
	emit_signal("challenge_down", type, pos)

func reset():
	level_counter = 0
	Player._set_health(40)
	Player._set_max_health(40)
	Player._set_damage(1)
	Player._set_speed(5)
	"""TODO write empty inventory function in inventory """

#
#export var health: int = 40 setget _set_health, _get_health
#export var max_health: int = 40 setget _set_max_health, _get_max_health
#export var strength: int = 1 setget _set_strength, _get_strength
#export var defence: int = 1 setget _set_defence, _get_defence
#export var speed: int = 1 setget _set_speed, _get_speed
#export var agility: int = 1 setget _set_agility, _get_agility
#export var dexterity: int = 1 setget _set_dexterity, _get_dexterity
#export var damage: int = 1 setget _set_damage, _get_damage
