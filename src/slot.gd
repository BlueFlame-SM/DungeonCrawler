# Source: https://github.com/arkeve/Godot-Inventory-System

extends Panel

var default_tex = preload("res://art/item_slot_default_background.png")
var empty_tex = preload("res://art/item_slot_empty_background.png")

var default_style: StyleBoxTexture = null
var empty_style: StyleBoxTexture = null

var ItemClass = preload("res://scenes/item.tscn")
var item = null

func _ready():
	default_style = StyleBoxTexture.new()
	empty_style = StyleBoxTexture.new()
	default_style.texture = default_tex
	empty_style.texture = empty_tex
	
	# Puts random item in slot.
#	if randi() % 2 == 0:
#		item = ItemClass.instance()
#		add_child(item)
#	refresh_style()
#
# If an item is in a slot, the slot is highligthed.
func refresh_style():
	if item == null:
		set('custom_styles/panel', empty_style)
	else:
		set('custom_styles/panel', default_style)
		
# Function for picking item from slot.
func pickFromSlot():
	remove_child(item)
	var inventoryNode = find_parent("Inventory")
	inventoryNode.add_child(item)
	item = null
	refresh_style()
	
# Function for putting item into slot.
func putIntoSlot(new_item, picked_up):
	item = new_item
	if picked_up == 1:
		# wait for luuk
		pass
		
	item.position = Vector2(0, 0)
	var inventoryNode = find_parent("Inventory")
	if picked_up == 0:
		inventoryNode.remove_child(item)

	add_child(item)
	refresh_style()
	
func initialize_item(item_name, item_quantity):
	if item == null:
		item = ItemClass.instance()
		add_child(item)
		item.set_item(item_name, item_quantity)
	else:
		item.set_item(item_name, item_quantity)
	refresh_style()
