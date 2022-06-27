extends Popup


# The two checkboxes that control the settings
onready var window_check = $MarginContainer/VBoxContainer/GridContainer/DisplayCheck
onready var vsync_check = $MarginContainer/VBoxContainer/GridContainer/VsyncCheck


func _ready():
	"""
	Hide GUI and set initial values in the Settings pop-up
	"""
	Gui.get_child(0).hide()
	window_check.text = "Off"
	if OS.vsync_enabled == true:
		vsync_check.text = "On"
		vsync_check.pressed = true
	else:
		vsync_check.text = "Off"
		vsync_check.pressed = false


func _on_DisplayCheck_toggled(button_pressed):
	"""
	Enter full screen or exit full screen depending on the checkbox
	"""
	if button_pressed == true:
		OS.window_fullscreen = true
		window_check.text = "On"
	else:
		OS.window_fullscreen = false
		window_check.text = "Off"


func _on_VsyncCheck_toggled(button_pressed):
	"""
	Enable vsync or disable vsync depending on the checkbox
	"""
	if button_pressed == true:
		OS.vsync_enabled = true
		vsync_check.text = "On"
	else:
		OS.vsync_enabled = false
		vsync_check.text = "Off"


func _on_BackButton_pressed():
	"""
	Close pop-up when Back button is pressed
	"""
	hide()