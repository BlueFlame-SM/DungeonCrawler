# Source: https://github.com/arkeve/Godot-Inventory-System

extends Node2D

const SlotClass = preload("res://inventory/slot.gd")
onready var inventory_slots = $GridContainer.get_children()
onready var hotbar_slots = get_parent().find_node("Hotbar").find_node("GridContainer").get_children()
onready var slots
onready var timer = $Timer

var holding_item = null
var use_item_slot: SlotClass = null
var use_item = null
var equipped_slot: SlotClass = null
var equiped_item = null
var potion = false

signal use_melee_weapon()
signal use_health_potion()
signal use_potion()
signal use_permanent_stat_increase()

func _ready():
	PlayerInventory.connect("inventory_updated", self, "initialize_inventory")
	get_parent().find_node("Hotbar").connect("inventory_updated", self, "initialize_inventory")
	if get_parent().find_node("GridContainer2"):
		slots = get_parent().find_node("GridContainer2").get_children()
	slots += hotbar_slots + inventory_slots
	for i in range(slots.size()):
		slots[i].connect("gui_input", self, "slot_gui_input", [slots[i]])
		slots[i].slot_index = i
		slots[i].slot_type = SlotClass.SlotType.INVENTORY
	initialize_inventory()
#	emit_signal("inventory_updated")

#const PlayerInventory = preload("res://src/PlayerInventory.gd")
func initialize_inventory():
#	var slots = inventory_slots.get_children()
	for i in range(slots.size()):
		if PlayerInventory.inventory.has(i):
			slots[i].initialize_item(PlayerInventory.inventory[i][0], PlayerInventory.inventory[i][1])

	equiped_item = slots[0].item

func slot_gui_input(event: InputEvent, slot: SlotClass):
	# When a mouseclick occurs, check if it is a left mouse click.
	if event is InputEventMouseButton:
		# Edge case to check if there are items to click.
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
#				slot_white(slot)
				left_click_not_holding_item(slot)
		# Consumes an item.
		if event.button_index == BUTTON_RIGHT && event.pressed:
			consume_item(slot)

func consume_item(slot):
	if !slot.item:
		return -1
	var category = JsonData.item_data[slot.item.item_name]["ItemCategory"]
	if category == "melee_weapon":
		use_item = slot.item
		emit_signal("use_" + category)
		var old_equiped_item = slots[0].item
		PlayerInventory.remove_item(slot)
		PlayerInventory.remove_item(slots[0])
		PlayerInventory.add_item_to_empty_slot(use_item, slots[0])
		if old_equiped_item != null:
			PlayerInventory.add_item_to_empty_slot(old_equiped_item, slot)
		else:
			slot.pickFromSlot()
		initialize_inventory()
	elif category == "potion":
		use_item = slot.item
		if potion == false:
			emit_signal("use_potion")
			potion = true
			timer.start()
			if slot.item.item_quantity == 1:
				slot.remove_child(use_item)
				slot.item = null
				slot.refresh_style()
			PlayerInventory.add_item_quantity(slot, -1)
			initialize_inventory()
	else:
		use_item = slot.item
		use_item_slot = slot
		emit_signal("use_" + category)
		var stack_size = int(JsonData.item_data[slot.item.item_name]["StackSize"])
		if slot.item.item_quantity == 1:
			slot.remove_child(use_item)
			slot.item = null
			slot.refresh_style()
		PlayerInventory.add_item_quantity(slot, -1)
		initialize_inventory()

func _input(event):
	# location of item held gets updated by mouse location.
	if holding_item:
		holding_item.global_position = get_global_mouse_position()
	if event is InputEventKey:
		if event.pressed and [49,50,51,52,53].has(event.unicode):
			var slot = get_parent().find_node("Hotbar").find_node("HotbarSlot" + str(event.unicode - 48))
			consume_item(slot)

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

func _on_Timer_timeout():
	print("time")
	timer.stop()
	potion = false
