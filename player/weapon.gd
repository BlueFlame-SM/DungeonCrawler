"""
Code for the player weapon. When player attacks, the weapon collision box will
be rotated in the direction of the player. The collision box of the weapon
will only be enabled when the player is attacking.

HurtBox: The collision box of the weapon.
angle: The angle at which the player is standing in radians.
damage: The damage of the weapon.
"""


extends Area2D


onready var HurtBox = $HurtBox
var angle = PI/2


func _ready():
	"""
	The weapon collision box should be disabled upon starting the game.
	"""
	HurtBox.set_deferred("disabled", true)


func attack(direction: Vector2) -> void:
	"""
	When a player attacks, the weapon collision box is rotated in the direction of
	the player. The weapon collision box is also enabled.
	
	direction: The direction in which the player is standing.
	"""
	var new_angle = atan2(direction.y, direction.x)
	HurtBox.rotate(new_angle - angle)
	angle = new_angle
	HurtBox.disabled = false


func disableHurtBox():
	"""
	Disable the weapon collision box.
	"""
	HurtBox.disabled = true

