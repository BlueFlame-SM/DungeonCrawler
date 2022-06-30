"""
Code for the game over screen. This screen is shown when the player dies and
gives the player the option to respawn or return to the main menu.

anim_finished: false initially, true when the level-switch animation has
finished.
"""


extends Control


var anim_finished = false


func _ready():
	"""
	Hide the Player and the GUI, and set focus on the top button.
	"""
	Player.hide()
	Player.get_child(4).get_child(1).hide()
	Gui.get_child(0).hide()
	$MarginContainer2/VBoxContainer/Respawn.grab_focus()
	GlobalVars.level_counter = 1
	GlobalVars.reset()
	# Connect the anim_finished signal to determine when the animation
	# has finished.
	LevelSwitcher.connect("anim_finished",self,"button_disable")


func button_disable():
	"""
	Enable the disabled buttons when the animation is finished.
	"""
	anim_finished = true
	$MarginContainer2/VBoxContainer/Menu.disabled = false
	$MarginContainer2/VBoxContainer/Respawn.disabled = false


func _on_Respawn_pressed():
	"""
	When the player presses the respawn button, go back to the start level.
	"""
	GlobalVars.level_type = "start"
	LevelSwitcher.goto_scene("res://levels/LevelStart.tscn", false)


func _on_Menu_pressed():
	"""
	When the player presses the menu button, go back to the main menu.
	"""
	LevelSwitcher.goto_scene("res://interface/main_menu.tscn", false)
