#Source: https://www.youtube.com/watch?v=XHbrKdsZrxY&ab_channel=jmbiv


extends Node2D
#
#signal level_changed_to_boss(level_name)
#signal level_changed_to_shop(level_name)
#signal level_changed_to_lootbox(level_name)
export var next_scene_name: String = "res://Test_Mul-Level/TestLevel1.tscn"
signal gate_opens()


#This function should be called when the enemy is defeated. This should signal
#from enemy class.
func _on_LevelCompleted_pressed():
#	This signal should notify the level that the gates should now appear open.
#	This can be done by putting a second tilemap on top of the first one and
#	making this tilemap visible on signal
	emit_signal("gate_opens")
#	Collision box for gate enabled.
	$Gate_to_next_level/GateCollision.disabled = 0


# If the player collides with a gate collisionbox, go to scene
func _on_Gate_to_next_level_body_entered(body):
	if body.name == "Player":
		SsFade.goto_scene(next_scene_name)
