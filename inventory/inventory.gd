"""
	Script of inventory and hotbar.
	Initialises inventory, hotbar and slots.
	Handles all actions within the inventory and hotbar.
	Items can be moved and used.

	Global variables:
		Keeps track of wheter a slot is used,
		an item is hold and/or a potion is in use.

	Source: https://github.com/arkeve/Godot-Inventory-System
"""

extends Node2D

const SlotClass = preload("res://inventory/slot.gd")
onready var inventory_slots = $GridContainer.get_children()
onready var trash_slot = $GridContainer3.get_child(0)
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
	"""
	Function puts inventory and hotbar with all its slots in place.
	"""
	PlayerInventory.connect("inventory_updated", self, "initialize_inventory")
	get_parent().find_node("Hotbar").connect("inventory_updated", self, "initialize_inventory")
	if get_parent().find_node("GridContainer2"):
		slots = get_parent().find_node("GridContainer2").get_children()
	slots += hotbar_slots + inventory_slots + [trash_slot]
	for i in range(slots.size()):
		slots[i].connect("gui_input", self, "slot_gui_input", [slots[i]])
		slots[i].slot_index = i
		slots[i].slot_type = SlotClass.SlotType.INVENTORY
	initialize_inventory()


func initialize_inventory():
	"""
	Initiliases inventory.
	"""
	for i in range(slots.size()):
		if PlayerInventory.inventory.has(i):
			slots[i].initialize_item(PlayerInventory.inventory[i][0], PlayerInventory.inventory[i][1])
		else:
			slots[i].remove_child(slots[i].item)
			slots[i].item = null
			slots[i].refresh_style()

	equiped_item = slots[0].item
	if trash_slot.item != null:
		PlayerInventory.remove_item(trash_slot)
		trash_slot.remove_child(trash_slot.item)
		trash_slot.item = null
		trash_slot.refresh_style()


func slot_gui_input(event: InputEvent, slot: SlotClass):
	"""
	Function to handle what to do in case of a mouseclick.
	"""
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
	"""
	Function to consume an item.
	"""
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
	"""
	Keeps track of item hold.
	Location of item held gets updated by mouse location.
	"""
	if holding_item:
		holding_item.global_position = get_global_mouse_position()
	if GlobalVars.level_counter != 0:
		if event is InputEventKey:
			if event.pressed and [49,50,51,52,53].has(event.unicode):
				var slot = get_parent().find_node("Hotbar").find_node("HotbarSlot" + str(event.unicode - 48))
				consume_item(slot)


func left_click_empty_slot(slot):
	"""
	Left click on slot not containing item.
	"""
	PlayerInventory.add_item_to_empty_slot(holding_item, slot)
	slot.putIntoSlot(holding_item, 0)
	holding_item = null


func left_click_dif_item(event, slot):
	"""
	Item when you are already holding an item and
	left click on slot and containing a different kind of item.
	"""
	PlayerInventory.remove_item(slot)
	PlayerInventory.add_item_to_empty_slot(holding_item, slot)
	var temp_item = slot.item
	slot.pickFromSlot()
	temp_item.global_position = event.global_position
	slot.putIntoSlot(holding_item, 0)
	holding_item = temp_item


func left_click_same_item(slot):
	"""
	Item when you are already holding an item and
	left click on slot and containing the same kind of item.
	"""
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
	"""
	Item when you left click on slot and are not yet holding an item.
	"""
	PlayerInventory.remove_item(slot)
	holding_item = slot.item
	slot.pickFromSlot()
	holding_item.global_position = get_global_mouse_position()


func _on_Button_pressed():
	"""
	Thrashes item in trash item slot.
	"""
	initialize_inventory()


func _on_Timer_timeout():
	"""
	Checks that potion effect is stoped when timer is over.
	"""
	timer.stop()
	potion = false
