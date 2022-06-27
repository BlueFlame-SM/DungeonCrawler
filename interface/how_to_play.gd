extends Popup


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$Background/Keybindings.visible = false
	$Background/Gameplay.visible = true

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Close_pressed():
	hide()


func _on_Keybindings_pressed():
	$Background/Keybindings.visible = true
	$Background/Gameplay.visible = false


func _on_Gameplay_pressed():
	$Background/Gameplay.visible = true
	$Background/Keybindings.visible = false
