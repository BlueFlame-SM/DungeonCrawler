extends Area2D

# Area is not entered yet.
var area_entered = false
var opened_before = false
var items_chest = []
var item_options = JsonData.item_data.keys()

"""
If list contains strings, append strings to items_chest, otherwise append
item at passed index to items_chest
"""
func choose_items(list):
	if typeof(list[0]) == TYPE_STRING:
		for item in list:
			if item in item_options:
				items_chest.append(item)
	else:
		for item in list:
			items_chest.append(item_options[item])
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
	print(item_options)
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
