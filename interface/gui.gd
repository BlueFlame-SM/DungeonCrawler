"""
Code for the player health bar. The health bar is initialized to the correct
value and maximum value. It is updated when the player takes damage or heals.
The text next to the health bar is also updated according to the bar value.

numberLabel: The text next to the health bar displaying the value.
bar: The health bar object.
tween: The tween node needed to make the animation.
animatedHealth: The health value needed for the animation.
"""


# Source: https://docs.godotengine.org/en/3.0/getting_started/step_by_step/ui_code_a_life_bar.html


extends CanvasLayer


onready var numberLabel = $MarginContainer/HBoxContainer/PlayerBars/CanvasModulate/Bar/Count/Background/Number
onready var bar = $MarginContainer/HBoxContainer/PlayerBars/CanvasModulate/Bar/Gauge
onready var tween = $MarginContainer/Tween

var animatedHealth = 0


func _ready():
	"""
	Set initial maximum and current value of health bar and text label.
	"""
	# Initialize the value and maximum value of the bar.
	var playerMaxHealth = Player.max_health
	bar.max_value = playerMaxHealth
	bar.value = playerMaxHealth
	numberLabel.text = str(bar.value)
	animatedHealth = bar.value

	# Connect the healthChanged signal to determine when the health has changed.
	Player.connect("healthChanged", self, "_on_Player_healthChanged")


func _process(delta):
	"""
	Update text label and bar on interface.

	delta: The duration of one tick.
	"""
	# Update the maximum health value if that has changed.
	if bar.max_value != Player.max_health:
		bar.max_value = Player.max_health

	# Update the bar value.
	var roundValue = round(animatedHealth)
	numberLabel.text = str(roundValue)
	bar.value = animatedHealth


func update_health(newValue):
	"""
	Use animation to update value, so that bar and text increases/decrease
	gradually.

	newValue: The new value of the health bar.
	"""
	tween.interpolate_property(self, "animatedHealth", animatedHealth, newValue, 0.6, Tween.TRANS_LINEAR, Tween.EASE_IN)
	if not tween.is_active():
		tween.start()


func _on_Player_healthChanged(playerHealth, dif):
	"""
	Player sends signal when health changes, the health bar is updated.
	"""
	update_health(playerHealth)
