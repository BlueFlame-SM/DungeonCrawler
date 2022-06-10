extends KinematicBody2D

export (int) var speed = 200

var velocity = Vector2()
var screen_size

func _ready():
	screen_size = get_viewport_rect().size

func get_input():
	velocity = Vector2()
	if Input.is_action_pressed("right"):
		velocity.x += 1
	if Input.is_action_pressed("left"):
		velocity.x -= 1
	if Input.is_action_pressed("down"):
		velocity.y += 1
	if Input.is_action_pressed("up"):
		velocity.y -= 1
	velocity = velocity.normalized() * speed

func _physics_process(delta):
	get_input()
	velocity = move_and_slide(velocity)
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()
		
	position += velocity * delta
	# position.x = clamp(position.x, 0, screen_size.x)
	# position.y = clamp(position.y, 0, screen_size.y)
		
	if velocity.x > 0:
		$AnimatedSprite.animation = "walk_right"
		# $AnimatedSprite.flip_v = false
		# See the note below about boolean assignment.
		# $AnimatedSprite.flip_h = velocity.x < 0
	elif velocity.x < 0:
		$AnimatedSprite.animation = "walk_left"
		# $AnimatedSprite.flip_v = velocity.y > 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
