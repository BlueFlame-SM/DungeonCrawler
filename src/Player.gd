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

	if Input.is_action_just_pressed("E-key"):
		for body in $Area2D.get_overlapping_bodies():
			if body.is_in_group("item"):
				body.queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Player_mouse_exited():
	pass # Replace with function body.

var item_in_range = {}

# If player enters the pickup zone, this is excecuted.
func _on_Pickup_body_entered(body):
	item_in_range[body] = body
	$Prompt.visible = !$Prompt.visible
	print("Item detected")

# If player leaves the pickup zone, this is excecuted.
func _on_Pickup_body_exited(body):
	$Prompt.visible = !$Prompt.visible
	if item_in_range.has(body):
		item_in_range.erase(body)

# Checks for input.
func _input(event):
	if event.is_action_pressed("interact"):
		if item_in_range.size() > 0:
			var pickup_item = item_in_range.values()[0]
			pickup_item.pick_up_item(self)
			item_in_range.erase(pickup_item)


