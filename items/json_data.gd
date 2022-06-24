extends Node

var item_data: Dictionary = {
	"Broom": {
		"Item_category": "Melee weapon",
		"Damage": 1,
		"Attack_speed": 3,
		"Attack_type": "Swipe",
		"Range": 32,
		"Knockback": 64,
		"Poison": 0,
		"Bleed": 0,
		"Slow_enemy": 0,
		"Speed_change": 0,
		"Stun_chance": 0,	#Percentage chance for enemies to get stunned.
		"Stack_size": 1,
		"Description": "Used for sweeping both dust and enemies."
	},
	"Iron_sword": {
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
		"Stack_size": 1,
		"Description": "Simple, but effective."
	},
	"Steel_sword": {
		"Item_category": "Melee weapon",
		"Damage": 4,
		"Attack_speed": 5,
		"Attack_type": "Swipe",
		"Range": 32,
		"Knockback": 64,
		"Poison": 0,
		"Bleed": 0,
		"Slow_enemy": 0,
		"Speed_change": 0,
		"Stun_chance": 0,	#Percentage chance for enemies to get stunned.
		"Stack_size": 1,
		"Description": "Looks nothing special, but has sharp edges."
	},
	"Obsidian_sword": {
		"Item_category": "Melee weapon",
		"Damage": 6,
		"Attack_speed": 5,
		"Attack_type": "Swipe",
		"Range": 32,
		"Knockback": 64,
		"Poison": 0,
		"Bleed": 0,
		"Slow_enemy": 0,
		"Speed_change": 0,
		"Stun_chance": 0,	#Percentage chance for enemies to get stunned.
		"Stack_size": 1,
		"Description": "Made out of one of the hardest materials."
	},
	"Club": {
		"Item_category": "Melee weapon",
		"Damage": 6,
		"Attack_speed": 1,
		"Attack_type": "Swipe",
		"Range": 48,
		"Knockback": 128,
		"Poison": 0,
		"Bleed": 0,
		"Slow_enemy": 0,
		"Speed_change": -10,
		"Stun_chance": 20,	#Percentage chance for enemies to get stunned.
		"Stack_size": 1,
		"Description": "Great to keep enemies at bay."
	},
	"Posionous_blade": {
		"Item_category": "Melee weapon",
		"Damage": 1,
		"Attack_speed": 5,
		"Attack_type": "Poke",
		"Range": 32,
		"Knockback": 32,
		"Poison": 2,
		"Bleed": 0,
		"Slow_enemy": 0,
		"Speed_change": 0,
		"Stun_chance": 0,	#Percentage chance for enemies to get stunned.
		"Stack_size": 1,
		"Description": "Usefull to widdle down enemies over time."
	},
	"Spear": {
		"Item_category": "Melee weapon",
		"Damage": 4,
		"Attack_speed": 4,
		"Attack_type": "Poke",
		"Range": 64,
		"Poison": 0,
		"Bleed": 0,
		"Slow_enemy": 0,
		"Speed_change": 0,
		"Stack_size": 1,
		"Description": "Great to keep enemies at bay."
	},



	"Simple_bow": {
		"Item_category": "Bow",
		"Damage": 3,
		"Attack_speed": 4,
		"Attack_type": "Ranged",
		"Range_type": "Infinite",
		"Range": 0,
		"Splash_damage_range": 0,
		"SpLash_damage": 0,
		"Ammo_needed": "Yes",
		"Speed_change": 0,
		"Stack_size": 1,
		"Description": "Attack enemies while staying out of range."
	},
		"Long_bow": {
		"Item_category": "Bow",
		"Damage": 6,
		"Attack_speed": 2,
		"Attack_type": "Ranged",
		"Range_type": "Infinite",
		"Range": 0,
		"Splash_damage_range": 0,
		"SpLash_damage": 0,
		"Ammo_needed": "Yes",
		"Speed_change": 0,
		"Stack_size": 1,
		"Description": "Packs quite a punch, but fires slowly."
	},

	"Blowpipe": {
		"Item_category": "Darts",
		"Damage": 1,
		"Attack_speed": 8,
		"Attack_type": "Ranged",
		"Range_type": "Infinite",
		"Range": 0,
		"Splash_damage_range": 0,
		"SpLash_damage": 0,
		"Ammo_needed": "Yes",
		"Speed_change": 0,
		"Stack_size": 1,
		"Description": "Packs quite a punch, but fires slowly."
	},



	"Normal_arrow": {
		"Item_category": "Arrow",
		"Damage_change": 0,
		"Poison": 0,
		"Bleed": 0,
		"Slow_enemy": 0,
		"Stack_size": 20,
		"Description": "Ammunition for bows."
	},
	"Poison_arrow": {
		"Item_category": "Arrow",
		"Damage_change": -1,
		"Poison": 1,
		"Bleed": 0,
		"Slow_enemy": 0,
		"Stack_size": 10,
		"Description": "Ammunition for bows."
	},
	"Dart": {
		"Item_category": "Dart",
		"Damage_change": 0,
		"Poison": 0,
		"Bleed": 0,
		"Slow_enemy": 0,
		"Stack_size": 40,
		"Description": "Ammunition for blowpipe."
	},




##########################################################
########### Healing + temporary statt buffs ##############
##########################################################
	"Small_health_potion": {
		"Item_category": "Potion",
		"HP_healed": 5,
		"Duration": 0,
		"Speed": +0,
		"Damage": +0,
		"Attack speed": +0,
		"Infinite_ammo": "No",
		"Invisibility": "No",
		"Stack_size": 1,
		"Description": "For when you make a small mistake."
	},
	"Medium_health_potion": {
		"Item_category": "Potion",
		"HP_healed": 10,
		"Duration": 0,
		"Speed": +0,
		"Damage": +0,
		"Attack speed": +0,
		"Infinite_ammo": "No",
		"Invisibility": "No",
		"Stack_size": 1,
		"Description": "Doesn't smell nice, but might make you feel better."
	},
	"Large_health_potion": {
		"Item_category": "Potion",
		"HP_healed": 20,
		"Duration": 0,
		"Speed": +0,
		"Damage": +0,
		"Attack speed": +0,
		"Infinite_ammo": "No",
		"Invisibility": "No",
		"Stack_size": 1,
		"Description": "To use when you get to low."
	},
	"Speed_potion": {
		"Item_category": "Potion",
		"HP_healed": 0,
		"Duration": 10,
		"Speed": +3,
		"Damage": +0,
		"Attack speed": +2,
		"Infinite_ammo": "No",
		"Invisibility": "No",
		"Stack_size": 1,
		"Description": "Everything seems slow compared to this."
	},
	"Strength_potion": {
		"Item_category": "Potion",
		"HP_healed": 0,
		"Duration": 10,
		"Speed": 0,
		"Damage": +3,
		"Attack speed": +0,
		"Infinite_ammo": "No",
		"Invisibility": "No",
		"Stack_size": 1,
		"Description": "Everything seems slow compared to this."
	},
	"Potion_of_plenty": {
		"Item_category": "Potion",
		"HP_healed": 0,
		"Duration": 10,
		"Speed": 0,
		"Damage": +0,
		"Attack speed": +0,
		"Infinite_ammo": "Yes",
		"Invisibility": "No",
		"Stack_size": 1,
		"Description": "Get out of a pinch ammo get's low."
	},
	"Invisibility_potion": {
		"Item_category": "Potion",
		"HP_healed": 0,
		"Duration": 3,
		"Speed": 0,
		"Damage": +0,
		"Attack speed": +0,
		"Infinite_ammo": "No",
		"Invisibility": "Yes",
		"Stack_size": 1,
		"Description": "Dissapear into the void."
	},



##########################################################
######################## Fruit ###########################
##########################################################
	"Apple": {
		"Item_category": "Fruit",
		"HP_healed": 5,
		"Duration": 0,
		"Speed": +0,
		"Damage": +0,
		"Attack speed": +0,
		"Infinite_ammo": "No",
		"Invisibility": "No",
		"Stack_size": 1,
		"Description": "Refreshing."
	},
	"Grapes": {
		"Item_category": "Fruit",
		"HP_healed": 0,
		"Duration": 5,
		"Speed": +3,
		"Damage": +0,
		"Attack speed": +0,
		"Infinite_ammo": "No",
		"Invisibility": "No",
		"Stack_size": 1,
		"Description": "Makes you feel energetic."
	},
	"Pomegranate": {
		"Item_category": "Potion",
		"HP_healed": 0,
		"Duration": 5,
		"Speed": +0,
		"Damage": +3,
		"Attack speed": +0,
		"Infinite_ammo": "No",
		"Invisibility": "No",
		"Stack_size": 1,
		"Description": "Powerfull is an understatement for this fruit."
	},
	"Nectar": {
		"Item_category": "Potion",
		"HP_healed": 0,
		"Duration": 10,
		"Speed": +0,
		"Damage": +0,
		"Attack speed": +3,
		"Infinite_ammo": "No",
		"Invisibility": "No",
		"Stack_size": 1,
		"Description": "Really sweet."
	},

##########################################################
############### Permanent statt buffs ####################
##########################################################
	"Max_health_potion": {
		"Item_category": "Permanent_stat_increase",
		"Max_HP": +3,
		"Speed": +0,
		"Damage": +0,
		"Attack speed": +0,
		"Stack_size": 1,
		"Description": "."
	},
	"Max_speed_potion": {
		"Item_category": "Permanent_stat_increase",
		"Max_HP": +0,
		"Speed": +1,
		"Damage": +0,
		"Attack speed": +0,
		"Stack_size": 1,
		"Description": "."
	},
	"Max_strength_potion": {
		"Item_category": "Permanent_stat_increase",
		"Max_HP": +0,
		"Speed": +0,
		"Damage": +2,
		"Attack speed": +0,
		"Stack_size": 1,
		"Description": "."
	},
		"Max_attack_speed_potion": {
		"Item_category": "Permanent_stat_increase",
		"Max_HP": +0,
		"Speed": +0,
		"Damage": +0,
		"Attack speed": +1,
		"Stack_size": 1,
		"Description": "."
	},


##########################################################
######################### MONEY ##########################
##########################################################
	"Coin": {
		"Item_category": "Money",
		"Value": 1,
		"Stack_size": 999,
		"Description": "Looks shiny."
	},


##########################################################
######################### ARMOR ##########################
##########################################################
	"Leather_helmet": {
		"Item_category": "Helmet",
		"Armor": 3,	# Percentage less damage.
		"Speed": +0,
		"Stack_size": 1,
		"Description": "Better than nothing."
	},
	"Iron_helmet": {
		"Item_category": "Helmet",
		"Armor": 5,	# Percentage less damage.
		"Speed": +0,
		"Stack_size": 1,
		"Description": "Helpfull to keep your head a bit safer."
	},
	"Obsidian_helmet": {
		"Item_category": "Helmet",
		"Armor": 8,	# Percentage less damage.
		"Speed": +0,
		"Stack_size": 1,
		"Description": "Looks impenetrable."
	},
	"Aerodynamic_helmet": {
		"Item_category": "Helmet",
		"Armor": 3,	# Percentage less damage.
		"Speed": +1,
		"Stack_size": 1,
		"Description": "You can feel the wind blow through your hair."
	},
	"Lead_helmet": {
		"Item_category": "Pants",
		"Armor": 10,	# Percentage less damage.
		"Speed": -2,
		"Stack_size": 1,
		"Description": "Wearing this you'll have a heavy head."
	},

	"Leather_tunic": {
		"Item_category": "Chest_plate",
		"Armor": 3,	# Percentage less damage.
		"Speed": +0,
		"Stack_size": 1,
		"Description": "Hopefully it helps."
	},
	"Iron_chest_plate": {
		"Item_category": "Chest_plate",
		"Armor": 5,	# Percentage less damage.
		"Speed": +0,
		"Stack_size": 1,
		"Description": "Can slow down a sword when in need."
	},
	"Obsidian_chest_plate": {
		"Item_category": "Chest_plate",
		"Armor": 8,	# Percentage less damage.
		"Speed": +0,
		"Stack_size": 1,
		"Description": "Nothing will get through this."
	},
	"T-shirt": {
		"Item_category": "Chest_plate",
		"Armor": 3,	# Percentage less damage.
		"Speed": +1,
		"Stack_size": 1,
		"Description": "Some casual clothing."
	},
	"Lead_chest_plate": {
		"Item_category": "Chest_plate",
		"Armor": 10,	# Percentage less damage.
		"Speed": -2,
		"Stack_size": 1,
		"Description": "Heavy, but very protective."
	},

	"Leather_pants": {
		"Item_category": "Pants",
		"Armor": 3,	# Percentage less damage.
		"Speed": +0,
		"Stack_size": 1,
		"Description": "Doesn't feel really secure."
	},
	"Iron_pants": {
		"Item_category": "Pants",
		"Armor": 5,	# Percentage less damage.
		"Speed": +0,
		"Stack_size": 1,
		"Description": "To protect  your privates."
	},
	"Obsidian_pants": {
		"Item_category": "Pants",
		"Armor": 8,	# Percentage less damage.
		"Speed": +0,
		"Stack_size": 1,
		"Description": "Not super comfortable."
	},
	"Jogging_pants": {
		"Item_category": "Pants",
		"Armor": 3,	# Percentage less damage.
		"Speed": +1,
		"Stack_size": 1,
		"Description": "Is nice and loose."
	},
	"Lead_pants": {
		"Item_category": "Pants",
		"Armor": 10,	# Percentage less damage.
		"Speed": -2,
		"Stack_size": 1,
		"Description": "Just hope these pants won't drop down."
	},

	"Sandals": {
		"Item_category": "Shoes",
		"Armor": 3,	# Percentage less damage.
		"Speed": +0,
		"Stack_size": 1,
		"Description": "hopefully nobody wil step on your toes."
	},
	"Iron_shoes": {
		"Item_category": "Shoes",
		"Armor": 5,	# Percentage less damage.
		"Speed": +0,
		"Stack_size": 1,
		"Description": "Will prevent you from losing any toes."
	},
	"Obsidian_boots": {
		"Item_category": "Shoes",
		"Armor": 8,	# Percentage less damage.
		"Speed": +0,
		"Stack_size": 1,
		"Description": "Looks sturdy."
	},
	"Sneakers": {
		"Item_category": "Shoes",
		"Armor": 3,	# Percentage less damage.
		"Speed": +1,
		"Stack_size": 1,
		"Description": "Run like the wind."
	},
	"Lead_boots": {
		"Item_category": "Shoes",
		"Armor": 10,	# Percentage less damage.
		"Speed": -2,
		"Stack_size": 1,
		"Description": "Don't drag your feet to much."
	}
}

