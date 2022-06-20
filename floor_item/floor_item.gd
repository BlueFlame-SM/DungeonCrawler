class_name FloorItem
extends StaticBody2D

var player = null
var picked_up = false
export var item_name: String
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	# 0: branch, 1:poison, 2:sword, 3:shirt, 4:pants, 5:boots
	var options = ["tree_branch", "slime_potion","iron_sword", "brown_shirt", "blue_jeans", "brown_boots"]
	$AnimatedSprite.set_frame(options.find(item_name))
	
	
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
