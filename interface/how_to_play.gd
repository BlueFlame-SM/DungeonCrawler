extends Popup


func _ready():
	""" Upon opening the How To Play, show the Gameplay (Story 
		explenation). """
	$Background/Keybindings.visible = false
	$Background/Gameplay.visible = true


func _unhandled_input(event):
	""" Close the How To Play menu upon pressing Esc. """
	if event.is_action_pressed("ui_cancel"):
		hide()


func _on_Close_pressed():
	""" Close the How To Play menu upon pressing the Close button. """
	hide()


func _on_Keybindings_pressed():
	""" Upon selecting Keybindings, show the Keybindings node and hide the 
		Gameplay node.
	"""
	$Background/Keybindings.visible = true
	$Background/Gameplay.visible = false


func _on_Gameplay_pressed():
	""" Upon selecting Gameplay, show the Gameplay node and hide the 
		Keybindings node.
	"""
	$Background/Gameplay.visible = true
	$Background/Keybindings.visible = false
