extends "res://src/character.gd"


func _physics_process(delta: float) -> void:
	var direction = Vector2.ZERO
	if Input.is_action_pressed("left"):
		direction.x -= 1
	if Input.is_action_pressed("right"):
		direction.x += 1
	if Input.is_action_pressed("up"):
		direction.y -= 1
	if Input.is_action_pressed("down"):
		direction.y += 1

	var velocity = move_and_slide(move_in_direction(direction))
	position += velocity * delta


func _on_HazardNotifier_body_entered(body):
	damage(2)
	print("HP: {}/{}".format([health, max_health], "{}"))
