extends CanvasLayer

signal level_changed_to_boss(level_name)
signal level_changed_to_shop(level_name)
signal level_changed_to_lootbox(level_name)

#onready var anim = $AnimationPlayer
var ready_count = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	ready_count
	print(ready_count)
	$"/root/SpawnLevel".SpawnPath = "res://Test_Mul-Level/TestLevel3.tscn"
	pass # Replace with function body.

#Not called and not tested
#func cleanup():
#	if $door_shuts.playing():
#		yield($door_shuts, "finished")
#	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

export (String) var level_name = "level"

#func _on_gate_closing():
#	print("gate closing")

#The open gates become visible on the tilemap. Collision boxes for the gate
#start detecting bodies entering
func _on_LevelCompleted_pressed():
	$GatesOpen.visible = 1
	$Gate_to_boss/GateCollision1.disabled = 0
	$Gate_to_shop/GateCollision2.disabled = 0
	$Gate_to_lootbox/GateCollision3.disabled = 0


func enter_gate(body, path):
	if body.name == "Player":
#		anim.play("fade_in")
		SsFade.goto_scene(path)


func _on_Gate_to_boss_body_entered(body):
	enter_gate(body, "res://Test_Mul-Level/TestLevel1.tscn")
#	emit_signal("level_changed_to_boss", level_name)
#Source: https://www.youtube.com/watch?v=XHbrKdsZrxY&ab_channel=jmbiv


func _on_Gate_to_shop_body_entered(body):
	enter_gate(body, "res://Test_Mul-Level/TestLevel1.tscn")

func _on_Gate_to_lootbox_body_entered(body):
	enter_gate(body, "res://Test_Mul-Level/TestLevel1.tscn")


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


func _on_CheckBox_pressed():
	dead()
	pass # Replace with function body.

func dead():
	$"/root/SsFade".die($"/root/SpawnLevel".SpawnPath)
	pass
