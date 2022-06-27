extends Area2D

# Area is not entered yet.
var area_entered = false
var opened_before = false
var items_chest = []

#Probably needs to be rewritten to accept string list instead of indices
func choose_items(list):
	var options = ["tree_branch", "slime_potion","iron_sword", "brown_shirt", "blue_jeans", "brown_boots"]
	for item in list:
		items_chest.append(options[item])
	return items_chest

# If the area is entered, and the E button is pressed,
# the chest will open.
func _process(delta):
	if area_entered == true and opened_before == false:
		if Input.is_action_just_pressed("pick_up"):
			opened_before = true
			GlobalVars.challenge_down()
			get_parent().get_node("Chest/AnimatedSprite").playing = false
			get_parent().get_node("Chest/AnimatedSprite").frame = 1
			open_chest()
			return

func open_chest():
	var item_count = items_chest.size()
	if item_count == 0:
		return
	var item_angle = 2 * PI / item_count
	var radius = 300
	var angle = 0

	for i in len(items_chest):
		var scene = load("res://floor_item/floor_item.tscn")
		var instance = scene.instance()
		instance.item_name = items_chest[i]

#		Spawn items around chest
		var direction = Vector2(cos(angle), sin(angle))
		instance.position = direction * radius
		instance.scale = Vector2(0.02, 0.02)
		var child = add_child(instance)
		angle += item_angle

# The area is entered.
func _on_Pickup_Chest_body_entered(body):
		area_entered = true

# The area is exited.
func _on_Pickup_Chest_body_exited(body):
	area_entered = false
