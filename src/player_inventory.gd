extends Node


const NUM_INVENTORY_SLOTS = 20

# slot index: [name, quantity]
var inventory = {
	0: ['iron_sword', 1]
}

func add_item(item_name, item_quantity):
	for item in inventory:
		print("item_name:", item_name)
		print("\n\nander dingetje:", inventory[item][0])
		if inventory[item][0] == item_name:
			#todo check slot is full
			inventory[item][1] += item_quantity
			return

	for i in range(NUM_INVENTORY_SLOTS):
		if inventory.has(i) == false:
			inventory[i] = [item_name, item_quantity]
			return
