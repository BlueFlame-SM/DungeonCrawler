# Source: https://github.com/arkeve/Godot-Inventory-System

extends Node2D

var item_name
var item_quantity
var options = JsonData.item_data.keys()


func _ready():
	randomize()
	var rand_val = randi() % 1 - 1
	var options = ["Iron_sword"]
	item_name = options[rand_val]
	$AnimatedSprite.animation = item_name

	# This line loads the stackszise of a item from the dictionary.
	var stack_size = int(JsonData.item_data[item_name]["StackSize"])
	item_quantity = randi() % stack_size + 1

	if stack_size == 1:
		$Label.visible = false
	else:
		$Label.text = String(item_quantity)

func set_item(nm, qt):
	item_name = nm
	item_quantity = qt
	$AnimatedSprite.animation = item_name

	var stack_size = int(JsonData.item_data[item_name]["StackSize"])
	if stack_size == 1:
		$Label.visible = false
	else:
		$Label.visible = true
		$Label.text = String(item_quantity)

# add item to stack.
func add_item_quantity(amount_to_add):
	item_quantity += amount_to_add
	$Label.text = String(item_quantity)

# remove item from stack.
func decrease_item_quantity(amount_to_remove):
	item_quantity -= amount_to_remove
	$Label.text = String(item_quantity)

