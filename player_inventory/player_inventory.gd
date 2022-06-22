extends Node

signal inventory_updated

const SLOT = preload("res://inventory/slot.gd")
const ITEM = preload("res://inventory_item/inventory_item.gd")
const NUM_INVENTORY_SLOTS = 20

# slot index: [name, quantity]
var inventory = {
	0: ['iron_sword', 1],
	1: ["slime_potion", 45],
	2: ["slime_potion", 50],
	3: ["slime_potion", 30]
}

func add_item(item_name, item_quantity):
	for item in inventory:
		print("item_name:", item_name)
		print("\n\nander dingetje:", inventory[item][0])
		if inventory[item][0] == item_name:
			var stack_size = int(JsonData.item_data[item_name]["StackSize"])
			var able_to_add = stack_size - inventory[item][1]
			if able_to_add >= item_quantity:
				inventory[item][1] += item_quantity
				emit_signal("inventory_updated")
				return
			else:
				inventory[item][1] += able_to_add
				item_quantity = item_quantity - able_to_add

	for i in range(NUM_INVENTORY_SLOTS):
		if inventory.has(i) == false:
			inventory[i] = [item_name, item_quantity]
			emit_signal("inventory_updated")
			return

func add_item_to_empty_slot(item, slot):
	inventory[slot.slot_index] = [item.item_name, item.item_quantity]

func remove_item(slot):
	inventory.erase(slot.slot_index)
	
func add_item_quantity(slot, quantity):
	inventory[slot.slot_index][1] += quantity	
	
