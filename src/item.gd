extends StaticBody2D

var player = null
var picked_up = false

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
# Function called every in-game tick.
func _physics_process(delta):
	
	# If item is picked up, animation plays, and item is removed.
	if picked_up == true:
		if self.scale.x > 0:
			self.scale.x -= 0.1
			self.scale.y -= 0.1
			
		if self.scale.x < 0.2:
			queue_free()

# Function called when the item is picked up.
func pick_up_item(body):
	player = body
	picked_up = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
