#Source: https://docs.godotengine.org/en/3.0/getting_started/step_by_step/ui_code_a_life_bar.html

extends CanvasLayer


# Health bar variables
onready var numberLabel = $MarginContainer/BossBar/Count/Background/Number
onready var bar = $MarginContainer/BossBar/Gauge
onready var tween = $Tween

var animatedHealth = 0


func _ready():
	"""
	Set initial maximum and current value of health bar
	"""
	# $CanvasModulate.color.a = 100
	var parPos = get_parent().position
	parPos.y -= 80
	parPos.x -= 40
	offset = parPos
	var bossMaxHealth = get_parent().max_health
	bar.max_value = bossMaxHealth
	bar.value = bossMaxHealth
	numberLabel.text = str(bar.value)
	animatedHealth = bar.value
	get_parent().connect("healthChanged", self, "_on_boss_healthChanged")


func _process(delta):
	"""
	Update text label and bar on interface.
	"""
	# Set the health bar size to the current max_health if it was changed.
	if bar.max_value != get_parent().max_health:
		bar.max_value = get_parent().max_health

	var parPos = get_parent().position
	parPos.y -= 80
	parPos.x -= 40
	offset = parPos
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


func _on_boss_healthChanged(newValue, dif):
	update_health(newValue)

