class_name KinematicCharacter2D
extends KinematicBody2D


onready var status = get_node("Status")
onready var controller = get_node("Controller")


func _physics_process(delta):
	var velocity = controller.direction
	velocity = velocity.normalized()
	velocity = velocity * status.speed
	velocity = move_and_slide(velocity)
	position += velocity * delta

