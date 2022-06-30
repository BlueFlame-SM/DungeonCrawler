extends Control
var anim_finished = false


func _ready():
	Player.hide()
	Player.get_child(4).get_child(1).hide()
	Gui.get_child(0).hide()
	$MarginContainer2/VBoxContainer/Respawn.grab_focus()
	LevelSwitcher.connect("anim_finished",self,"test")

func test():
	anim_finished = true
	$MarginContainer2/VBoxContainer/Menu.disabled = false
	$MarginContainer2/VBoxContainer/Respawn.disabled = false

func _on_Respawn_pressed():
#	if LevelSwitcher.get_child(0).current_animation != "die":
	GlobalVars.level_type = "start"
	LevelSwitcher.goto_scene("res://levels/LevelStart.tscn", false)


func _on_Menu_pressed():
#	if LevelSwitcher.get_child(0).current_animation != "die":
	LevelSwitcher.goto_scene("res://interface/main_menu.tscn", false)
