class_name FloorItem
extends RigidBody2D

var player = null
var picked_up = false
export var item_name: String
var options = JsonData.item_data.keys()
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	# 0: branch, 1:poison, 2:sword, 3:shirt, 4:pants, 5:boots
	$AnimatedSprite.set_frame(options.find(item_name))
	$AnimatedSprite.animation = item_name
#	$AnimatedSprite.scale.x = 3
#	$AnimatedSprite.scale.y = 3


# Function called every in-game tick.
func _physics_process(delta):

	# If item is picked up, animation plays, and item is removed.
	if picked_up == true:
		if self.scale.x > 0:
			self.scale.x -= 0.1
			self.scale.y -= 0.1

		if self.scale.x < 0.2:
			PlayerInventory.add_item(item_name, 1)
			queue_free()


# Function called when the item is picked up.
func pick_up_item(body):
	player = body
	picked_up = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
