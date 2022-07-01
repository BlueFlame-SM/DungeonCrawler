"""
This script is to keep variables that need to be globally accessed. Because it also contains
functions this script could have been more appropriately (re)named, but due to time limits we decided
not to risk introducing new errors.
"""


extends Node

var level_type = "start"

var level_counter = 0
var dmg_reset = 1

signal challenge_down(type, pos)

func challenge_down(type, pos=Vector2.ZERO):
	"""
		This function is used to communicate between two non-global scripts
		that a level is one step closer to being completed.
	"""
	emit_signal("challenge_down", type, pos)

func reset():
	"""
		This function gets called to reset all variables when a player dies and
		needs to start over.
	"""
	level_counter = 0
	Player.reset()
	Player._set_max_health(40)
	Player._set_health(40)
	PlayerInventory.reset_inventory()
