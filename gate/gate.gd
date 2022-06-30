#Source: https://www.youtube.com/watch?v=XHbrKdsZrxY&ab_channel=jmbiv

"""
TODO:
	- make gates appear different based on whats behind it (DONE)
	- Fix bug that doesnt make gate appear open in level 5 (DONE)
	- Dont select current level (DONE)
	- Fix animation issue (DONE)
	- Fix bugs in gate differentiation. (DONE)
	- Fix double level, spawns enemies (i think fixed)
	- Get chest from misha fork and spawn in loot levels DONE
	- Make loot or enemy spawn in level. DONE
	- Level script detects if level completed (chest opened/enemies defeated) DONE
	- Fix that chest cant be opened in level 9 (DONE)

	- Multiple enemies???? Count them
	- Enemy can kill player (Not sure if this works for every enemy)
	- On death, dont play gate close but some sort of dying sound.
	- Sound on slash
	- Make what is in chest variable
	- Connect (random) sprite to enemy
"""

extends Area2D
export var next_scene_name: String = "res://levels/Level5.tscn"

var rng = RandomNumberGenerator.new()
var nxt_lvl_nr
var combat_levels = [1, 2, 3, 4, 5, 6, 7, 8 ,9 ,11]
var loot_levels = [1, 2, 3, 4, 5, 6, 7, 8 ,9, 10 ,11]
var cur_lvl_nr
var gate_type = "loot"
var odds_chest_room = 0.1


func _ready():
	print(GlobalVars.level_type)
	rng.randomize()
#	As a default, no sign should appear above the gate unless its determined
#	what is behind the gate.
	if GlobalVars.level_type != "preboss":
		$BossOpen.visible = false
		$LootOpen.visible = false
#	In case the gate belongs to the startlevel, the gate should be open.
#	Otherwise the collision box should be disabled so the player cant collide
	if GlobalVars.level_type != "start" and GlobalVars.level_type != "preboss":
		$GateCollision.disabled = true
#	To get the scene that this gate leads to, determine what kind of gate it is
	if GlobalVars.level_type == "preboss":
		gate_type = "bigboss"
		if GlobalVars.level_counter %9 == 0:
			next_scene_name = "res://levels/LevelHydra.tscn"
		elif GlobalVars.level_counter %5 == 0:
			next_scene_name = "res://levels/LevelLion.tscn"
		else:
			gate_type = "endboss"
			next_scene_name = "res://levels/LevelCerberus.tscn"
	else:
		next_scene_name = det_gate_type()



"""
This function picks randomly either a loot level or combat level as next level.
The current level layout is removed as an option to not get two similar levels
in a row. The appropriate sign on top of the gate appears visible.
"""
func det_gate_type():
	if GlobalVars.level_type == "endboss":
		gate_type = "credits"
		return "res://interface/credits.tscn"
	if GlobalVars.level_counter % 4 == 0 and GlobalVars.level_counter != 0:
		$LootOpen.visible = true
		gate_type = "preboss"
		return "res://levels/pre_boss_battle1.tscn"

	cur_lvl_nr = int(get_parent().name.right(5))
	combat_levels.erase(cur_lvl_nr)
	loot_levels.erase(cur_lvl_nr)
	if rng.randf_range(0, 1) < odds_chest_room:
		nxt_lvl_nr = loot_levels[randi() % loot_levels.size()]
		$LootOpen.visible = true
		gate_type = "loot"
	else:
		nxt_lvl_nr = combat_levels[randi() % combat_levels.size()]
		$BossOpen.visible = true
		gate_type = "boss"
#	Returns the name of the next level
	return "res://levels/Level" + String(nxt_lvl_nr) + ".tscn"


"""
If the player collides with a gate collisionbox, the player stops moving.
The next level type is set to the type of the gate that was entered. We then
go to the next level.
"""
func _on_Gate_body_entered(body):
	if body.name == "Player":
		Player.can_move = false
		GlobalVars.level_type = gate_type
		LevelSwitcher.goto_scene(next_scene_name)


"""
Gets signal from level script that level has been completed. Gate collisions
are disabled so that player can collide with them.
"""
func _on_gates_open():
	$GateCollision.disabled = 0

