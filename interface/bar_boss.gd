"""
Code for the enemy health bar. The health bar is initialized to the appropriate
value and maximum value. It is also placed above the head of an enemy. Every
time the health changes, the bar is updated with an animation and the text is
updated to show the new value.

numberLabel: The text next to the health bar displaying the value.
bar: The health bar object.
tween: The tween node needed to make the animation.
animatedHealth: The health value needed for the animation.
"""


# Source: https://docs.godotengine.org/en/3.0/getting_started/step_by_step/ui_code_a_life_bar.html


extends CanvasLayer


onready var numberLabel = $MarginContainer/BossBar/Count/Background/Number
onready var bar = $MarginContainer/BossBar/Gauge
onready var tween = $Tween

var animatedHealth = 0


func _ready():
	"""
	Set initial maximum and current value of health bar, and place it in the
	correct position.
	"""
	# Set the bar to the correct position.
	var parPos = get_parent().position
	parPos.y -= 80
	parPos.x -= 40
	offset = parPos
	
	# Set the correct values of the bar.
	var bossMaxHealth = get_parent().max_health
	bar.max_value = bossMaxHealth
	bar.value = bossMaxHealth
	numberLabel.text = str(bar.value)
	animatedHealth = bar.value
	
	# Connect the healthChanged signal to determine when the health changes.
	get_parent().connect("healthChanged", self, "_on_boss_healthChanged")


func _process(delta):
	"""
	Update text label and bar on interface.
	
	delta: Time difference of a single tick.
	"""
	# Update the maximum value of the bar if it has changed.
	if bar.max_value != get_parent().max_health:
		bar.max_value = get_parent().max_health

	# Set the bar to the correct position.
	var parPos = get_parent().position
	parPos.y -= 80
	parPos.x -= 40
	offset = parPos
	
	# Set the new value of the health bar and the text next to it.
	var roundValue = round(animatedHealth)
	numberLabel.text = str(roundValue)
	bar.value = animatedHealth


func update_health(newValue):
	"""
	Use animation to update value, so that bar and text increases/decrease
	gradually.
	
	newValue: The new value of the health of the enemy.
	"""
	tween.interpolate_property(self, "animatedHealth", animatedHealth, newValue, 0.6, Tween.TRANS_LINEAR, Tween.EASE_IN)
	if not tween.is_active():
		tween.start()


func _on_boss_healthChanged(newValue, dif):
	"""
	When the health of the enemy changes, update the healthbar.
	
	newValue: The new value of the enemy's health.
	dif: The difference between the old and new health.
	"""
	update_health(newValue)

