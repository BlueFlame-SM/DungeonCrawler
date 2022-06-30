"""
	Script for the inventory item.
	Able to set items and add and subtract of item stacks.

	Global variables:
		keep track of kind of item and quantity.

	Source: https://github.com/arkeve/Godot-Inventory-System
"""

extends Node2D

var item_name
var item_quantity
var options = JsonData.item_data.keys()

func set_item(nm, qt):
	"""
	Sets an inventory item.
	"""
	item_name = nm
	item_quantity = qt
	$AnimatedSprite.animation = item_name

	var stack_size = int(JsonData.item_data[item_name]["StackSize"])
	if stack_size == 1:
		$Label.visible = false
	else:
		$Label.visible = true
		$Label.text = String(item_quantity)


func add_item_quantity(amount_to_add):
	"""
	Add item to stack of items.
	"""
	item_quantity += amount_to_add
	$Label.text = String(item_quantity)


func decrease_item_quantity(amount_to_remove):
	"""
	Remove item from stack of items.
	"""
	item_quantity -= amount_to_remove
	$Label.text = String(item_quantity)
