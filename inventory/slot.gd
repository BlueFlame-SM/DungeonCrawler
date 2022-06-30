"""
	Script that handles action with slots.
	Generates different slot textures for when an item is in it and when not.
	Able to initialise items into slots and move items between slots.

	Global variables:
		define the possible textures of the slots.
		keep track of the slots and if it contains an item.

	Source: https://github.com/arkeve/Godot-Inventory-System
"""

extends Panel

var default_tex = preload("res://inventory/sprites/item_slot_default_background.png")
var empty_tex = preload("res://inventory/sprites/item_slot_empty_background.png")
var default_style: StyleBoxTexture = null
var empty_style: StyleBoxTexture = null
var ItemClass = preload("res://inventory_item/inventory_item.tscn")
var item = null
var slot_index
var slot_type

enum SlotType {
	HOTBAR = 0,
	INVENTORY,
}

func _ready():
	"""
	Defines the textures for the slots.
	"""
	default_style = StyleBoxTexture.new()
	empty_style = StyleBoxTexture.new()
	default_style.texture = default_tex
	empty_style.texture = empty_tex
	refresh_style()

func refresh_style():
	"""
	If an item is in a slot, the slot is highligthed.
	When hovering over an item a textblock is shown.
	"""
	if item == null:
		set('custom_styles/panel', empty_style)
	else:
		set('custom_styles/panel', default_style)
		var category = JsonData.item_data[item.item_name]["ItemCategory"]
		if category == "melee_weapon":
			hint_tooltip = str(item.item_name) + ", \nDamage:" + str(JsonData.item_data[item.item_name]["Damage"]) + ", \nRange:" + str(JsonData.item_data[item.item_name]["Range"]) + ", \nAttack speed:" + str(JsonData.item_data[item.item_name]["Attack_speed"])
		if category == "health_potion":
			hint_tooltip = str(item.item_name) + ", \nHP healed:" + str(JsonData.item_data[item.item_name]["HP_healed"])
		if category == "potion":
			hint_tooltip = str(item.item_name) + ", \nDuration:" + str(JsonData.item_data[item.item_name]["Duration"]) + ", \nSpeed:" + str(JsonData.item_data[item.item_name]["Speed"]) + ", \nDamage:" + str(JsonData.item_data[item.item_name]["Damage"])
		if category == "permanent_stat_increase":
			hint_tooltip = str(item.item_name) + ", \nMax HP:" + str(JsonData.item_data[item.item_name]["Max_HP"]) + ", \nSpeed:" + str(JsonData.item_data[item.item_name]["Speed"])  + ", \nDamage:" + str(JsonData.item_data[item.item_name]["Damage"]) + ", \nAttack speed:" + str(JsonData.item_data[item.item_name]["Attack_speed"])


func pickFromSlot():
	"""
	Function for picking item from slot.
	"""
	remove_child(item)
	var inventoryNode = find_parent("CanvasLayer")
	inventoryNode.add_child(item)
	item = null
	refresh_style()


func putIntoSlot(new_item, picked_up):
	"""
	Function for putting item into slot.
	"""
	item = new_item
	if picked_up == 1:
		pass

	item.position = Vector2(0, 0)
	var inventoryNode = find_parent("CanvasLayer")
	if picked_up == 0:
		inventoryNode.remove_child(item)
	add_child(item)
	refresh_style()

func initialize_item(item_name, item_quantity):
	"""
	Sets item inside of slot.
	"""
	if item == null:
		item = ItemClass.instance()
		add_child(item)
		item.set_item(item_name, item_quantity)
	else:
		item.set_item(item_name, item_quantity)
	refresh_style()
