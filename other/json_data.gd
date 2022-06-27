extends Node

var item_data: Dictionary = {
  "tree_branch": {
	"ItemCategory": "Weapon",
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
	"ItemAttack": 3,
	"ItemSpeed": 0.75, 
	"StackSize": 1,
	"Description": "Quite a rusty sword, but should be able to get the job done."
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
#	json_data = JSON.parse(file_data.get_as_text())
#	file_data.close()
#	return json_data.result
