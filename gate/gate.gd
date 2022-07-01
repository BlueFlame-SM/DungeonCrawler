"""
	This program implements the gate that is used to crossover levels.
	It is a simple crossover gate that takes two levels and returns a new level.
	The new level is a combination of the two input levels.
	The new level is created by randomly choosing a point in the level and then
	copying the contents of the two levels to the new level.

	Source: https://www.youtube.com/watch?v=XHbrKdsZrxY&ab_channel=jmbiv
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
		elif GlobalVars.level_counter %13 == 0:
			gate_type = "endboss"
			next_scene_name = "res://levels/LevelCerberus.tscn"
	else:
		next_scene_name = det_gate_type()




func det_gate_type():
	"""
		This function picks randomly either a loot level or combat level as next level.
		The current level layout is removed as an option to not get two similar levels
		in a row. The appropriate sign on top of the gate appears visible.
	"""
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
	return "res://levels/Level" + String(nxt_lvl_nr) + ".tscn"



func _on_Gate_body_entered(body):
	"""
		If the player collides with a gate collisionbox, the player stops moving.
		The next level type is set to the type of the gate that was entered. We then
		go to the next level.
	"""
	if body.name == "Player":
		Player.can_move = false
		GlobalVars.level_type = gate_type
		LevelSwitcher.goto_scene(next_scene_name)


func _on_gates_open():
	$GateCollision.disabled = 0

