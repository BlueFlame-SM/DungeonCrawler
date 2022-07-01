extends Node

var level_type = "start"

var level_counter = 0
var dmg_reset = 1

signal challenge_down(type, pos)

func challenge_down(type, pos=Vector2.ZERO):
	emit_signal("challenge_down", type, pos)

func reset():
	level_counter = 0
	Player.reset()
	Player._set_max_health(40)
	Player._set_health(40)
	PlayerInventory.reset_inventory()
