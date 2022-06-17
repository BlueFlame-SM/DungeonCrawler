extends Node



#onready var anim = $AnimationPlayer
var ready_count = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	$"/root/Player".position = Vector2(10,0)
	$"/root/Player".is_dead = false
#	$"/root/SpawnLevel".SpawnPath = "res://Test_Mul-Level/TestLevel3.tscn"
	pass # Replace with function body.

export (String) var level_name = "level"

#func _on_gate_closing():
#	print("gate closing")


func _on_CheckBox_pressed():
	dead()
	pass # Replace with function body.

func dead():
	$"/root/LevelSwitcher".die("res://LevelSwitcher/Level0.tscn")

	pass


func _on_Styx_body_entered(body):
	LevelSwitcher.die("res://LevelSwitcher/Level0.tscn")
	pass # Replace with function body.
