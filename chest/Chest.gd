extends Area2D

# Area is not entered yet.
var area_entered = false
var opened_before = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# If the area is entered, and the E button is pressed,
# the chest will open.
func _process(delta):
	if area_entered == true and opened_before == false:
		if Input.is_action_just_pressed("pick_up"):
			opened_before = true
			GlobalVars.challenge_down()
			get_parent().get_node("Chest/AnimatedSprite").playing = false
			get_parent().get_node("Chest/AnimatedSprite").frame = 1

			var item_count = 5
			var item_angle = 2.0 * PI / item_count
			var radius = 400
			var angle = 0
			var x_pos = 0
			var y_pos = 0
			for i in item_count:
				var scene = load("res://floor_item/floor_item.tscn")

				var instance = scene.instance()
				var options = ["tree_branch", "slime_potion","iron_sword", "brown_shirt", "blue_jeans", "brown_boots"]
				instance.item_name = options[i]
#				instance.visibilityEnablers
				var direction = Vector2(cos(angle), sin(angle))
				instance.position = direction * radius
				instance.scale = Vector2(0.02, 0.02)
#				instance.linear_velocity = Vector2(10, 10)
#				instance.add_force(Vector2(1, 1), Vector2(10, 10))
				var child = add_child(instance)
				angle += item_angle
			area_entered = false
			return


# The area is entered.
func _on_Pickup_Chest_body_entered(body):
		area_entered = true


# The area is exited.
func _on_Pickup_Chest_body_exited(body):
	area_entered = false
