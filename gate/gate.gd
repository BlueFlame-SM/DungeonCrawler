#Source: https://www.youtube.com/watch?v=XHbrKdsZrxY&ab_channel=jmbiv


extends Area2D
export var next_scene_name: String = "res://levels/Level0.tscn"
signal gate_opens()
var rng = RandomNumberGenerator.new()
var nxt_lvl_nr


#Optie: gooi randomise in levelswitcher.
func _ready():
#	dit werkt nog niet? snap die seed niet echt
	rng.randomize()
	if self.name != "StartGate":
		nxt_lvl_nr = String(rng.randi_range(1, 3))
		print(nxt_lvl_nr)
		next_scene_name = "res://levels/Level" + nxt_lvl_nr + ".tscn"


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
		Player.can_move = false
		if next_scene_name == "res://levels/Level0.tscn":
			LevelSwitcher.die()
		else:
			LevelSwitcher.goto_scene(next_scene_name)



