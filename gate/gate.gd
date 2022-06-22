#Source: https://www.youtube.com/watch?v=XHbrKdsZrxY&ab_channel=jmbiv

"""
TODO:
	- make gates appear different based on whats behind it
	- Make loot or enemy spawn in level.
	- Dont select current level (done)
	- Fix animation issue
"""

extends Area2D
export var next_scene_name: String = "res://levels/Level5.tscn"
signal gate_opens()
var rng = RandomNumberGenerator.new()
var nxt_lvl_nr
var combat_levels = [4, 5, 6, 7, 8 ,9 ,11, 12, 13, 14]
var loot_levels = [4, 5, 6, 7, 8 ,9, 10 ,11, 12, 13, 14]
var cur_lvl_nr


#Optie: gooi randomise in levelswitcher.
func _ready():
#	dit werkt nog niet? snap die seed niet echt
	rng.randomize()
	next_scene_name = det_gate_type()

func det_gate_type():
	cur_lvl_nr = int(get_parent().name.right(5))
	if rng.randf_range(0, 1) < 0.3:
		loot_levels.erase(cur_lvl_nr)
		nxt_lvl_nr = loot_levels[randi() % loot_levels.size()]
	else:
		combat_levels.erase(cur_lvl_nr)
		nxt_lvl_nr = combat_levels[randi() % combat_levels.size()]
	return "res://levels/Level" + String(nxt_lvl_nr) + ".tscn"




#This function should be called when the enemy is defeated. This should signal
#from enemy class.
func _on_LevelCompleted_pressed():
#	This signal should notify the level that the gates should now appear open.
#	This can be done by putting a second tilemap on top of the first one and
#	making this tilemap visible on signal
	emit_signal("gate_opens")
#	Collision box for gate enabled.
	$GateCollision.disabled = 0


# If the player collides with a gate collisionbox, go to scene
func _on_Gate_body_entered(body):
	if body.name == "Player":
		print("gate body entered")
		Player.can_move = false
		LevelSwitcher.goto_scene(next_scene_name)

