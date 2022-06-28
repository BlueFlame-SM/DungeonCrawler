extends Control


func _ready():
	Player.hide()
	Player.get_child(4).get_child(1).hide()
	Gui.get_child(0).hide()
	$MarginContainer2/VBoxContainer/Respawn.grab_focus()


func _on_Respawn_pressed():
	GlobalVars.level_type = "start"
	LevelSwitcher.goto_scene("res://levels/LevelStart.tscn", false)


func _on_Menu_pressed():
	LevelSwitcher.goto_scene("res://interface/main_menu.tscn", false)
