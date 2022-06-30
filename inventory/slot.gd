# Source: https://github.com/arkeve/Godot-Inventory-System

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
	default_style = StyleBoxTexture.new()
	empty_style = StyleBoxTexture.new()
	default_style.texture = default_tex
	empty_style.texture = empty_tex
	# Puts random item in slot.
#	if randi() % 2 == 0:
#		item = ItemClass.instance()
#		add_child(item)
	refresh_style()
#
# If an item is in a slot, the slot is highligthed.
func refresh_style():
	if item == null:
		set('custom_styles/panel', empty_style)
		hint_tooltip = ""
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
		
		if category == "lion_hide":
			hint_tooltip = str(item.item_name) + ", \nDefence:" + str(JsonData.item_data[item.item_name]["Defence"])
#
#		# Permanent potions
#		if item.item_name == "max_health_potion":
#			hint_tooltip = "Max_health_potion, \nMax_HP: +3, \nSpeed: +0, \nDamage: +0, \nAttack speed: +0"
#		if item.item_name == "max_speed_potion":
#			hint_tooltip = "Max_speed_potion, \nMax_HP: +0, \nSpeed: +1, \nDamage: +0, \nAttack speed: +0"
#		if item.item_name == "max_strength_potion":
#			hint_tooltip = "Max_strength_potion, \nMax_HP: +0, \nSpeed: +0, \nDamage: +2, \nAttack speed: +0"
#		if item.item_name == "max_attack_speed_potion":
#			hint_tooltip = "Max_attack_speed_potion, \nMax_HP: +0, \nSpeed: +0, \nDamage: +0, \nAttack speed: +1"
#
#		# Healing potions
#		if item.item_name =="small_health_potion":
#			hint_tooltip = "Small_health_potion, \nHP_healed: 5"
#		if item.item_name =="medium_health_potion":
#			hint_tooltip = "Medium_health_potion, \nHP_healed: 10"
#		if item.item_name =="large_health_potion":
#			hint_tooltip = "Large_health_potion, \nHP_healed: 20"
#
#		# Temporary stat buffs
#		if item.item_name =="speed_potion":
#			hint_tooltip = "Speed_potion, \nDuration: 10, \nSpeed: +3, \nDamage: +0, \nAttack speed: +2, Infinite_ammo: False, \nInvisibility: False"
#		if item.item_name =="strength_potion":
#			hint_tooltip = "Strength_potion, \nDuration: 10, \nSpeed: +0, \nDamage: +3, \nAttack speed: +0, Infinite_ammo: False, \nInvisibility: False"
#		if item.item_name =="invisibility_potion":
#			hint_tooltip = "Invisibility_potion, \nDuration: 3, \nSpeed: +0, \nDamage: +0, \nAttack speed: +0, Infinite_ammo: False, \nInvisibility: True"

# Function for picking item from slot.
func pickFromSlot():
	remove_child(item)
	var inventoryNode = find_parent("CanvasLayer")
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
	var inventoryNode = find_parent("CanvasLayer")
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
