# Source: https://github.com/arkeve/Godot-Inventory-System

extends Node2D

const SlotClass = preload("res://inventory/slot.gd")
onready var inventory_slots = $GridContainer
var holding_item = null

func _ready():
	PlayerInventory.connect("inventory_updated", self, "initialize_inventory")
	var slots = inventory_slots.get_children()
	for i in range(slots.size()):
		slots[i].connect("gui_input", self, "slot_gui_input", [slots[i]])
		slots[i].slot_index = i
	initialize_inventory()

#const PlayerInventory = preload("res://src/PlayerInventory.gd")
func initialize_inventory():
	var slots = inventory_slots.get_children()
	for i in range(slots.size()):
		if PlayerInventory.inventory.has(i):
			slots[i].initialize_item(PlayerInventory.inventory[i][0], PlayerInventory.inventory[i][1])
			
func slot_gui_input(event: InputEvent, slot: SlotClass):
	# When a mouseclick occurs, check if it is a left mouse click.
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT && event.pressed:
			if holding_item != null:
				# When there is no item in the slot, put the new item in the slot.
				if !slot.item:
					left_click_empty_slot(slot)
				# When there is already an item in the slot.
				else:
					# If it is a different item, swap the item held by the item in the slot.
					if holding_item.item_name != slot.item.item_name:
						left_click_dif_item(event, slot)
					# If it is the same item, check if it can be stacked. 
					else:
						left_click_same_item(slot)
						
			# If nothing is held yet, here the item will be picked up.
			elif slot.item:
				left_click_not_holding_item(slot)

	
func _input(_event):
	# location of item held gets updated by mouse location.
	if holding_item:
		holding_item.global_position = get_global_mouse_position()

func left_click_empty_slot(slot):
	PlayerInventory.add_item_to_empty_slot(holding_item, slot)
	slot.putIntoSlot(holding_item, 0)
	holding_item = null

func left_click_dif_item(event, slot):
	PlayerInventory.remove_item(slot)
	PlayerInventory.add_item_to_empty_slot(holding_item, slot)
	var temp_item = slot.item
	slot.pickFromSlot()
	temp_item.global_position = event.global_position
	slot.putIntoSlot(holding_item, 0)
	holding_item = temp_item

func left_click_same_item(slot):
	var stack_size = int(JsonData.item_data[slot.item.item_name]["StackSize"])
#	var stack_size = int(JsonData.item_data[item_name]["StackSize"])
	var able_to_add = stack_size - slot.item.item_quantity
	if able_to_add >= holding_item.item_quantity:
		PlayerInventory.add_item_quantity(slot, holding_item.item_quantity)
		slot.item.add_item_quantity(holding_item.item_quantity)
		holding_item.queue_free()
		holding_item = null
	else:
		PlayerInventory.add_item_quantity(slot, able_to_add)
		slot.item.add_item_quantity(able_to_add)
		holding_item.decrease_item_quantity(able_to_add)

func left_click_not_holding_item(slot):
	PlayerInventory.remove_item(slot)
	holding_item = slot.item
	slot.pickFromSlot()
	holding_item.global_position = get_global_mouse_position()
