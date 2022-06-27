extends Node

var item_data: Dictionary = {
  "tree_branch": {
	"ItemCategory": "Resource",
	"StackSize": 99,
	"Description": "A sturdy tree branch that can be used for crafting."
  },
  "slime_potion": {
	"ItemCategory": "Consumable",
	"AddHealth": 5,
	"AddEnergy": 32,
	"StackSize": 99,
	"Description": "It smells like medicine."
  },
  "iron_sword": {
	"ItemCategory": "Weapon",
#	"ItemAttack": 3,
#	"ItemSpeed": 0.75,
	"StackSize": 1,
	"Item_category": "Melee weapon",
	"Damage": 3,
	"Attack_speed": 5,
	"Attack_type": "Swipe",
	"Range": 32,
	"Knockback": 64,
	"Poison": 0,
	"Bleed": 0,
	"Slow_enemy": 0,
	"Speed_change": 0,
	"Stun_chance": 0,	#Percentage chance for enemies to get stunned.
#	"Stack_size": 1,
	"Description": "Simple, but effective."
  },
  "brown_shirt": {
	"ItemCategory": "Shirt",
	"StackSize": 1,
	"Description": "A brown shirt!!"
  },
  "blue_jeans": {
	"ItemCategory": "Pants",
	"StackSize": 1,
	"Description": "Blue jeans!!"
  },
  "brown_boots": {
	"ItemCategory": "Shoes",
	"StackSize": 1,
	"Description": "Some dirty boots!!"
  }
}
#
#func _ready():
#	item_data = LoadData("res://items/ItemData.json")
#
## Parses the jason file and saves it as a dictionary within the script.
#func LoadData(file_path):
#	var json_data
#	var file_data = File.new()
#
#	file_data.open(file_path, File.READ)
