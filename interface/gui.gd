#Source: https://docs.godotengine.org/en/3.0/getting_started/step_by_step/ui_code_a_life_bar.html

extends CanvasLayer


# Health bar variables
onready var numberLabel = $MarginContainer/HBoxContainer/PlayerBars/CanvasModulate/Bar/Count/Background/Number
onready var bar = $MarginContainer/HBoxContainer/PlayerBars/CanvasModulate/Bar/Gauge
onready var tween = $MarginContainer/Tween

var animatedHealth = 0


func _ready():
	"""
	Set initial maximum and current value of health bar
	"""
	var playerMaxHealth = Player.max_health
	bar.max_value = playerMaxHealth
	bar.value = playerMaxHealth
	numberLabel.text = str(bar.value)
	animatedHealth = bar.value
	Player.connect("healthChanged", self, "_on_Player_healthChanged")


func _process(delta):
	"""
	Update text label and bar on interface.
	"""
	if bar.max_value != Player.max_health:
		bar.max_value = Player.max_health
	var roundValue = round(animatedHealth)
	numberLabel.text = str(roundValue)
	bar.value = animatedHealth


func update_health(newValue):
	"""
	Use animation to update value, so that bar and text increases/decrease
	gradually.
	"""
	tween.interpolate_property(self, "animatedHealth", animatedHealth, newValue, 0.6, Tween.TRANS_LINEAR, Tween.EASE_IN)
	if not tween.is_active():
		tween.start()

func _on_Player_healthChanged(playerHealth, dif):
	"""
	Player sends signal when health changes.
	"""
	update_health(playerHealth)
