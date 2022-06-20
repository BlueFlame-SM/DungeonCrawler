extends Area2D

onready var HurtBox = $HurtBox
var angle = PI/2
export var damage = 2


# Collision should be disabled
func _ready():
	HurtBox.set_deferred("disabled", true)

func attack(direction: Vector2) -> void:
	var new_angle = atan2(direction.y, direction.x)
	HurtBox.rotate(new_angle - angle)
	angle = new_angle
	HurtBox.disabled = false

func disableHurtBox():
	HurtBox.disabled = true




# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

