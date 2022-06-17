#Source: https://www.youtube.com/watch?v=XHbrKdsZrxY&ab_channel=jmbiv


extends Area2D
#
#signal level_changed_to_boss(level_name)
#signal level_changed_to_shop(level_name)
#signal level_changed_to_lootbox(level_name)
export var next_scene_name: String = "res://LevelSwitcher/Level0.tscn"
signal gate_opens()
var rng = RandomNumberGenerator.new()
var nxt_lvl_nr

func _ready():
	rng.randomize()
	if self.name != "StartGate":
		nxt_lvl_nr = String(rng.randi_range(0, 3))
		print(nxt_lvl_nr)
		next_scene_name = "res://LevelSwitcher/Level" + nxt_lvl_nr + ".tscn"


#This function should be called when the enemy is defeated. This should signal
#from enemy class.
func _on_LevelCompleted_pressed():
	print("button pressed")
#	This signal should notify the level that the gates should now appear open.
#	This can be done by putting a second tilemap on top of the first one and
#	making this tilemap visible on signal
	emit_signal("gate_opens")
#	Collision box for gate enabled.
	$GateCollision.disabled = 0


# If the player collides with a gate collisionbox, go to scene
func _on_Gate_body_entered(body):
	if body.name == "Player":
		print("ienteredgate")
		if next_scene_name == "res://LevelSwitcher/Level0.tscn":
			LevelSwitcher.die(next_scene_name)
		else:
			LevelSwitcher.goto_scene(next_scene_name)



