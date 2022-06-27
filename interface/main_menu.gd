extends Control


func _ready():
	"""
	Hide GUI and Player on main menu and set focus on top button
	"""
	Player.hide()
	$MarginContainer/VBoxContainer/Buttons/NewGame.grab_focus()
	print(Player._get_health())

#func _process(delta):
#	print(Player._get_health())

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()


func _on_NewGame_pressed():
	"""
	If a new game is started, switch to LevelStart scene
	"""
	LevelSwitcher.goto_scene("res://levels/LevelStart.tscn")
	Player.show()

func _on_Quit_pressed():
	"""
	If Quit button is pressed, quit game
	"""
	get_tree().quit()


func _on_Settings_pressed():
	"""
	If Settings button is pressed, show Settings pop-up
	"""
	$SettingsMenu.popup()


func _on_How_to_play_pressed():
	"""
	If How To Play button is pressed, show How To Play pop-up.
	"""
	$How_to_play.popup()
