#Source: https://www.youtube.com/watch?v=XHbrKdsZrxY&ab_channel=jmbiv

"""
TODO:
	- make gates appear different based on whats behind it (DONE)
	- Fix bug that doesnt make gate appear open in level 5 (DONE)
	- Dont select current level (DONE)
	- Fix animation issue (DONE)
	- Fix bugs in gate differentiation. (DONE)
	- Fix double level, spawns enemies (i think fixed)
	- Multiple enemies???? Count them (DONE)
	- Get chest from misha fork and spawn in loot levels DONE
	- Make loot or enemy spawn in level. DONE
	- Level script detects if level completed (chest opened/enemies defeated) DONE

	- Enemy can kill player (pls outsource)
	- On death, dont play gate close but some sort of dying sound.
	- Sound on slash
"""

extends Area2D
export var next_scene_name: String = "res://levels/Level5.tscn"

var rng = RandomNumberGenerator.new()
var nxt_lvl_nr
var combat_levels = [4, 5, 6, 7, 8 ,9 ,11, 12, 13, 14]
var loot_levels = [4, 5, 6, 7, 8 ,9, 10 ,11, 12, 13, 14]
var cur_lvl_nr
var gate_type = "loot"


#Optie: gooi randomise in levelswitcher.
func _ready():
#	dit werkt nog niet? snap die seed niet echt
	rng.randomize()
	$BossOpen.visible = false
	$LootOpen.visible = false
	if self.name != "StartGate":
		$GateCollision.disabled = true
	next_scene_name = det_gate_type()


func det_gate_type():
	cur_lvl_nr = int(get_parent().name.right(5))
	combat_levels.erase(cur_lvl_nr)
	loot_levels.erase(cur_lvl_nr)
	if rng.randf_range(0, 1) < 0.3:
		nxt_lvl_nr = loot_levels[randi() % loot_levels.size()]
		$LootOpen.visible = true
		gate_type = "loot"
	else:
		nxt_lvl_nr = combat_levels[randi() % combat_levels.size()]
		$BossOpen.visible = true
		gate_type = "boss"
	print("my gate type is")
	print(gate_type)

	return "res://levels/Level" + String(nxt_lvl_nr) + ".tscn"



# If the player collides with a gate collisionbox, go to scene
func _on_Gate_body_entered(body):
	if body.name == "Player":
		Player.can_move = false
		print(gate_type)
		print(get_parent().name)
		GlobalVars.level_type = gate_type
		print("going to ")
		print(next_scene_name)
		LevelSwitcher.goto_scene(next_scene_name)


#Gets signal from level script that level has been completed.
func _on_gates_open():
	print("gates open")
	$GateCollision.disabled = 0

