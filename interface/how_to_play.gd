"""
Code for the How to Play screen. This screen is shown when the player presses
a How to Play button. THe player can view the game objective, the keybindings,
and the inventory mechanics.
"""


extends Popup


func _ready():
	"""
	Upon opening the How To Play, show the Gameplay (Story explenation). 
	"""
	$Background/Keybindings.visible = false
	$Background/Gameplay.visible = true
	$Background/Inventory.visible = false


func _unhandled_input(event):
	"""
	Close the How To Play menu upon pressing Esc.
	"""
	if event.is_action_pressed("ui_cancel"):
		hide()


func _on_Close_pressed():
	"""
	Close the How To Play menu upon pressing the Close button.
	"""
	hide()


func _on_Keybindings_pressed():
	"""
	Upon selecting Keybindings, show the Keybindings node and hide the 
	Gameplay and Inventory node.
	"""
	$Background/Keybindings.visible = true
	$Background/Gameplay.visible = false
	$Background/Inventory.visible = false


func _on_Gameplay_pressed():
	"""
	Upon selecting Gameplay, show the Gameplay node and hide the 
	Keybindings and Inventory node.
	"""
	$Background/Gameplay.visible = true
	$Background/Keybindings.visible = false
	$Background/Inventory.visible = false


func _on_Inventory_pressed():
	"""
	Upon selecting Inventory, show the Inventory node and hide the 
	Keybindings and Gameplay node.
	"""
	$Background/Inventory.visible = true
	$Background/Gameplay.visible = false
	$Background/Keybindings.visible = false
