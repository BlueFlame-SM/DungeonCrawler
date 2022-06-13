extends CanvasLayer

signal level_changed_to_boss(level_name)
signal level_changed_to_shop(level_name)
signal level_changed_to_lootbox(level_name)

# Called when the node enters the scene tree for the first time.
func _ready():
#	connect("gate_closing", self, "_on_gate_closing")
	pass # Replace with function body.

#Not called and not tested
func cleanup():
	if $door_shuts.playing():
		yield($door_shuts, "finished")
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

export (String) var level_name = "level"

#func _on_gate_closing():
#	print("gate closing")


func _on_LevelCompleted_pressed():
#	TODO: make gate unenterable collision till level completen
	$GatesOpen.visible = 1
	$Gate_to_boss/GateCollision1.disabled = 0
	$Gate_to_shop/GateCollision2.disabled = 0
	$Gate_to_lootbox/GateCollision3.disabled = 0
#	$TileMap.set_cell(384, 0, 1)
	print("gates should open on completion")
	pass # Replace with function body.



func _on_Gate_to_boss_body_entered(body):
	if body.name != "Player":
		return
	emit_signal("level_changed_to_boss", level_name)
#Source: https://www.youtube.com/watch?v=XHbrKdsZrxY&ab_channel=jmbiv

func _on_Gate_to_shop_body_entered(body):
	if body.name != "Player":
		return
	emit_signal("level_changed_to_shop", level_name)

func _on_Gate_to_lootbox_body_entered(body):
	if body.name != "Player":
		return
	emit_signal("level_changed_to_lootbox", level_name)


func _on_Scene_Switcher_gate_closing():
#	https://freesound.org/people/InspectorJ/sounds/431118/
#	Free but not for (commercial?) use, look at this

	print("gate closing!")
#	Deze wil niet werken?????
	$door_shuts.play()
	print($door_shuts.playing)








#Tasks:
#	multiple gates lead to multiple levels
#	sound on entering new level
#	add gate opens on completion
