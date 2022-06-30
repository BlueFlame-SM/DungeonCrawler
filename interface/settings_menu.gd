"""
Code for the Settings menu popup. This popup is shown when the player
pressses a Settings button. The player gets the option to enable and disable
fullscreen and vsync, and can adjust the background music volume. 

window_check: The checkbox for the fullscreen option.
vsync_check: The checkbox for the vsync option.
slider: The slider for the background music volume.
volume_label: The label next to the music slider.
"""


extends Popup


onready var window_check = $MarginContainer/VBoxContainer/GridContainer/DisplayCheck
onready var vsync_check = $MarginContainer/VBoxContainer/GridContainer/VsyncCheck
onready var slider = $MarginContainer/VBoxContainer/GridContainer2/MarginContainer/Volume/MarginContainer/MusicSlider
onready var volume_label = $MarginContainer/VBoxContainer/GridContainer2/MarginContainer/Volume/Label


func _ready():
	"""
	Hide GUI and set initial values in the Settings pop-up.
	"""
	Gui.get_child(0).hide()
	window_check.text = "Off"
	volume_label.text = str(db2linear(GlobalAudioStreamPlayer.volume_db)) + "%"
	slider.value = db2linear(GlobalAudioStreamPlayer.volume_db)
	if OS.vsync_enabled == true:
		vsync_check.text = "On"
		vsync_check.pressed = true
	else:
		vsync_check.text = "Off"
		vsync_check.pressed = false


func _on_DisplayCheck_toggled(button_pressed):
	"""
	Enter full screen or exit full screen depending on the checkbox.
	"""
	if button_pressed == true:
		OS.window_fullscreen = true
		window_check.text = "On"
	else:
		OS.window_fullscreen = false
		window_check.text = "Off"


func _on_VsyncCheck_toggled(button_pressed):
	"""
	Enable vsync or disable vsync depending on the checkbox.
	"""
	if button_pressed == true:
		OS.vsync_enabled = true
		vsync_check.text = "On"
	else:
		OS.vsync_enabled = false
		vsync_check.text = "Off"


func _on_BackButton_pressed():
	"""
	Close pop-up when Back button is pressed.
	"""
	hide()


func _on_MusicSlider_value_changed(value):
	"""
	Adjust the volume depending on the value of the slider.
	"""
	GlobalAudioStreamPlayer.volume_db = linear2db(value)
	volume_label.text = str(value) + "%"
