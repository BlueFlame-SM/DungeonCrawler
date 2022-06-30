"""
Code for the pause menu. This menu will open when a player presses ESC when in
game. This menu gives the player the options to return to the game, to change
settings, to check the How to Play menu and to quit the game.

is_paused: true when the game is paused, false when the game is not paused.
"""

# Sources:
#	https://www.youtube.com/watch?v=Su3pU14YzeY

extends Control


var is_paused = false setget set_paused


func _unhandled_input(event):
	"""
	If ui_cancel is pressed, reverse the paused state. 
	
	event: The unhandled input event.
	"""
	if event.is_action_pressed("ui_cancel"):
		self.is_paused = !is_paused


func set_paused(value):
	"""
	Set the game pause state and visibility of the pause screen 
	according to the value.
	
	value: The new value of the is_paused variable.
	"""
	is_paused = value
	get_tree().paused = is_paused
	visible = is_paused
	$CenterContainer/VBoxContainer/Resume_button.grab_focus()


func _on_Resume_button_pressed():
	"""
	Set pause state to false if the resume button is pressed.
	"""
	self.is_paused = false


func _on_Quit_button_pressed():
	"""
	Quit the game once the quit button is pressed.
	"""
	get_tree().quit()


func _on_Settings_button_pressed():
	"""
	Show Settings menu upon settings button pressed.
	"""
	$SettingsMenu.popup()


func _on_Rules_button_pressed():
	"""
	Show How To Play menu upon Rules (How To Play) button pressed.
	"""
	$How_to_play.popup()
