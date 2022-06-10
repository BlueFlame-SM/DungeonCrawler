extends KinematicBody2D

export var speed: float = 200

var _velocity


func get_input():
	_velocity = Vector2.ZERO
	if Input.is_action_pressed("right"):
		_velocity.x += 1
	if Input.is_action_pressed("left"):
		_velocity.x -= 1
	if Input.is_action_pressed("down"):
		_velocity.y += 1
	if Input.is_action_pressed("up"):
		_velocity.y -= 1


func _physics_process(delta):
	get_input()

	_velocity = move_and_slide(_velocity)

	if _velocity.length() > 0:
		_velocity = _velocity.normalized() * speed
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()

	position += _velocity * delta
	# position.x = clamp(position.x, 0, screen_size.x)
	# position.y = clamp(position.y, 0, screen_size.y)

	if _velocity.x > 0:
		$AnimatedSprite.animation = "walk_right"
		# $AnimatedSprite.flip_v = false
		# See the note below about boolean assignment.
		# $AnimatedSprite.flip_h = _velocity.x < 0
	elif _velocity.x < 0:
		$AnimatedSprite.animation = "walk_left"
		# $AnimatedSprite.flip_v = _velocity.y > 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_HazardNotifier_body_entered(body):
	print(body)
