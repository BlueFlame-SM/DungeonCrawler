extends Control

var is_paused = false setget set_paused


func _unhandled_input(event):
	""" If ui_cancel is pressed, reverse the paused state. """
	if event.is_action_pressed("ui_cancel"):
		self.is_paused = !is_paused


func set_paused(value):
	""" Set the game pause state and visibility of the pause screen 
		according to the value.
	"""
	is_paused = value
	get_tree().paused = is_paused
	visible = is_paused
	$CenterContainer/VBoxContainer/Resume_button.grab_focus()


func _on_Resume_button_pressed():
	""" Set pause state to false if the resume button is pressed. """
	self.is_paused = false


func _on_Quit_button_pressed():
	""" Quit the game once the quit button is pressed. """
	get_tree().quit()


func _on_Settings_button_pressed():
	$SettingsMenu.popup()


func _on_Rules_button_pressed():
	$How_to_play.popup()
