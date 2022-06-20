extends "res://src/character.gd"

const slot = preload("res://src/slot.gd")
#var player_inventory = preload("res://src/player_inventory.gd")

#func _ready():
#	player_inventory = player_inventory.new()

func _physics_process(delta):
	var direction = Vector2()
	if Input.is_action_pressed("right"):
		direction.x += 1
	if Input.is_action_pressed("left"):
		direction.x -= 1
	if Input.is_action_pressed("down"):
		direction.y += 1
	if Input.is_action_pressed("up"):
		direction.y -= 1
	var velocity = move_in_direction(direction)
	position += move_and_slide(velocity) * delta
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()
		
	if velocity.x > 0:
		$AnimatedSprite.animation = "walk_right"
		# $AnimatedSprite.flip_v = false
		# See the note below about boolean assignment.
		# $AnimatedSprite.flip_h = velocity.x < 0
	elif velocity.x < 0:
		$AnimatedSprite.animation = "walk_left"
		# $AnimatedSprite.flip_v = velocity.y > 0


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
			
#			$Inventory.initialize_inventory()
			
			# Putting picked up item into inventory.
#			var myClass = slot.new()
#			myClass.putIntoSlot(pickup_item, 1)
#			var myClass = player_inventory.new()
#			myClass.add_item(pickup_item, 1)
			
#			player_inventory.add_item(pickup_item, 1)
			
#			print(pickup_item["item2"])
#			var picture = pickup_item.AnimatedSprite.get_sprite_frames()
#			print("picture: ", picture)
			
			item_in_range.erase(pickup_item)


func _on_HazardNotifier_body_entered(body):
	damage(2)
	print(health)
