"""
	Script for the chest.
	Functions to detect wheter a player is close enough to the chest to open it.
	When the chest is opened items are spwaned and thrown around the chest in a 
	circle.
	
	Global variables:
		area_entered: false when player is outside area chest, true when inside.
		opened_before: false when chest is opened before, true when not.
		items_chest: list of items inside of the chest.
		items_options: all possible items to be spawned out of the chest.
		
"""

extends Area2D

# Area is not entered yet.
var area_entered = false
var opened_before = false
var items_chest = []
var item_options = JsonData.item_data.keys()


func _ready():
	"""
	Makes items predetermined in a the preboss level.
	"""
	if GlobalVars.level_type == "preboss":
		choose_items(["Pomegranate", "Strength_potion", "Speed_potion", "Grape"])

func choose_items(list):
	"""
	If list contains strings, append strings to items_chest, otherwise append
	item at passed index to items_chest
	"""
	if typeof(list[0]) == TYPE_STRING:
		for item in list:
			if item in item_options:
				items_chest.append(item)
	else:
		for item in list:
			items_chest.append(item_options[item])
	return items_chest


func _process(delta):
	"""
	If the area is entered, and the E button is pressed,
	the chest will open.
	"""
	if area_entered == true and opened_before == false:
		if Input.is_action_just_pressed("pick_up"):
			opened_before = true
			GlobalVars.challenge_down("chest")
			get_parent().get_node("Chest/AnimatedSprite").playing = false
			get_parent().get_node("Chest/AnimatedSprite").frame = 1
			open_chest()
			return


func open_chest():
	"""
	Opens chest and throws items in a circle around the chest.
	"""
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

		# Spawn items around chest
		var direction = Vector2(cos(angle), sin(angle))
		instance.position = direction * radius
		instance.scale = Vector2(0.02, 0.02)
		var child = add_child(instance)
		angle += item_angle

# The area is entered.
func _on_Pickup_Chest_body_entered(body):
	"""
	Detects wheter the player is close enough to the chest to open it.
	"""
	if body.name == "Player":
		area_entered = true

# The area is exited.
func _on_Pickup_Chest_body_exited(body):
	"""
	Detects wheter the player is to far from the chest to open it.
	"""
	if body.name == "Player":
		area_entered = false
