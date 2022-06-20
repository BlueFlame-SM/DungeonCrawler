# Source: https://github.com/arkeve/Godot-Inventory-System

extends Node2D

const SlotClass = preload("res://src/slot.gd")
onready var inventory_slots = $GridContainer
var holding_item = null

func _ready():
	print("inv file reached")
	for inv_slot in inventory_slots.get_children():
		inv_slot.connect("gui_input", self, "slot_gui_input", [inv_slot])
	initialize_inventory()

#const player_inventory = preload("res://src/player_inventory.gd")
func initialize_inventory():
	var slots = inventory_slots.get_children()
	for i in range(slots.size()):
		if player_inventory.inventory.has(i):
			slots[i].initialize_item(player_inventory.inventory[i][0], player_inventory.inventory[i][1])
			
func slot_gui_input(event: InputEvent, slot: SlotClass):
	# When a mouseclick occurs, check if it is a left mouse click.
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT && event.pressed:
			if holding_item != null:
				# When there is no item in the slot, put the new item in the slot.
				if !slot.item:
					slot.putIntoSlot(holding_item, 0)
					holding_item = null
				# When there is already an item in the slot.
				else:
					# If it is a different item, swap the item held by the item in the slot.
					if holding_item.item_name != slot.item.item_name:
						var temp_item = slot.item
						slot.pickFromSlot()
						temp_item.global_position = event.global_position
						slot.putIntoSlot(holding_item, 0)
						holding_item = temp_item
					# If it is the same item, check if it can be stacked. 
					else:
						var stack_size = int(JsonData.item_data[slot.item.item_name]["StackSize"])
#						var stack_size = int(JsonData.item_data[item_name]["StackSize"])
						var able_to_add = stack_size - slot.item.item_quantity
						if able_to_add >= holding_item.item_quantity:
							slot.item.add_item_quantity(holding_item.item_quantity)
							holding_item.queue_free()
							holding_item = null
						else:
							slot.item.add_item_quantity(able_to_add)
							holding_item.decrease_item_quantity(able_to_add)
						
			# If nothing is held yet, here the item will be picked up.
			elif slot.item:
				holding_item = slot.item
				slot.pickFromSlot()
				holding_item.global_position = get_global_mouse_position()

	
func _input(_event):
	# location of item held gets updated by mouse location.
	if holding_item:
		holding_item.global_position = get_global_mouse_position()
