"""
Code for the main menu of the game. This menu will be shown at the start of
the game and at the end after the credits, and when a player chooses to
return to it after death. This menu gives the player the option to start a
new game, to change settings, to view the How to Play screen, and to quit the
game.
"""


extends Control


func _ready():
	"""
	Hide GUI and Player on main menu and set focus on top button.
	"""
	Player.hide()
	$MarginContainer/VBoxContainer/Buttons/NewGame.grab_focus()


func _unhandled_input(event):
	"""
	Quit the game when player presses ESC when on main menu.

	event: The unhandled input event.
	"""
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()


func _on_NewGame_pressed():
	"""
	If a new game is started, switch to LevelStart scene.
	"""
	GlobalVars.level_type = "start"
	GlobalVars.level_counter = 1
	GlobalVars.reset()
	LevelSwitcher.goto_scene("res://levels/LevelStart.tscn")



func _on_Quit_pressed():
	"""
	If Quit button is pressed, quit game.
	"""
	get_tree().quit()


func _on_Settings_pressed():
	"""
	If Settings button is pressed, show Settings pop-up.
	"""
	$SettingsMenu.popup()


func _on_How_to_play_pressed():
	"""
	If How To Play button is pressed, show How To Play pop-up.
	"""
	$How_to_play.popup()
