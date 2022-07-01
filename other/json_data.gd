extends Node


var item_data: Dictionary = {
	"Broom": {
		"ItemCategory": "melee_weapon",
		"Rarity": 1,
		"Damage": 2,
		"Attack_speed": 3,
		"Attack_type": "Swipe",
		"Range": 1,
		"Knockback": 64,
		"Poison": 0,
		"Bleed": 0,
		"Slow_enemy": 0,
		"Speed_change": 2,
		"Stun_chance": 0,	#Percentage chance for enemies to get stunned.
		"StackSize": 1,
		"Description": "Used for sweeping both dust and enemies."
	},
	"Iron_sword": {
		"ItemCategory": "melee_weapon",
		"Rarity": 2,
		"Damage": 3,
		"Attack_speed": 5,
		"Attack_type": "Swipe",
		"Range": 1,
		"Knockback": 64,
		"Poison": 0,
		"Bleed": 0,
		"Slow_enemy": 0,
		"Speed_change": 1,
		"Stun_chance": 0,	#Percentage chance for enemies to get stunned.
		"StackSize": 1,
		"Description": "Simple, but effective."
	},
	"Steel_sword": {
		"ItemCategory": "melee_weapon",
		"Rarity": 3,
		"Damage": 4,
		"Attack_speed": 5,
		"Attack_type": "Swipe",
		"Range": 1,
		"Knockback": 64,
		"Poison": 0,
		"Bleed": 0,
		"Slow_enemy": 0,
		"Speed_change": 0,
		"Stun_chance": 0,	#Percentage chance for enemies to get stunned.
		"StackSize": 1,
		"Description": "Looks nothing special, but has sharp edges."
	},
	"Obsidian_sword": {
		"ItemCategory": "melee_weapon",
		"Rarity": 5,
		"Damage": 6,
		"Attack_speed": 5,
		"Attack_type": "Swipe",
		"Range": 1,
		"Knockback": 64,
		"Poison": 0,
		"Bleed": 0,
		"Slow_enemy": 0,
		"Speed_change": 0,
		"Stun_chance": 0,	#Percentage chance for enemies to get stunned.
		"StackSize": 1,
		"Description": "Made out of one of the hardest materials."
	},
	"Club": {
		"ItemCategory": "melee_weapon",
		"Rarity": 3,
		"Damage": 6,
		"Attack_speed": 1,
		"Attack_type": "Swipe",
		"Range": 1.5,
		"Knockback": 128,
		"Poison": 0,
		"Bleed": 0,
		"Slow_enemy": 0,
		"Speed_change": -10,
		"Stun_chance": 20,	#Percentage chance for enemies to get stunned.
		"StackSize": 1,
		"Description": "Great to keep enemies at bay."
	},
#	"Posionous_blade": {
#		"ItemCategory": "melee_weapon",
#		"Rarity": 1,
#		"Damage": 2,
#		"Attack_speed": 5,
#		"Attack_type": "Poke",
#		"Range": 1,
#		"Knockback": 32,
#		"Poison": 2,
#		"Bleed": 0,
#		"Slow_enemy": 0,
#		"Speed_change": 0,
#		"Stun_chance": 0,	#Percentage chance for enemies to get stunned.
#		"StackSize": 1,
#		"Description": "Usefull to widdle down enemies over time."
#	},
	"Spear": {
		"ItemCategory": "melee_weapon",
		"Rarity": 4,
		"Damage": 4,
		"Attack_speed": 4,
		"Attack_type": "Poke",
		"Range": 2,
		"Poison": 0,
		"Bleed": 0,
		"Slow_enemy": 0,
		"Speed_change": 0,
		"StackSize": 1,
		"Description": "Great to keep enemies at bay."
	},



#	"Simple_bow": {
#		"ItemCategory": "bow",
#		"Damage": 3,
#		"Attack_speed": 4,
#		"Attack_type": "Ranged",
#		"Range_type": "Infinite",
#		"Range": 0,
#		"Splash_damage_range": 0,
#		"SpLash_damage": 0,
#		"Ammo_needed": true,
#		"Speed_change": 0,
#		"StackSize": 1,
#		"Description": "Attack enemies while staying out of range."
#	},
#		"Long_bow": {
#		"ItemCategory": "bow",
#		"Damage": 6,
#		"Attack_speed": 2,
#		"Attack_type": "Ranged",
#		"Range_type": "Infinite",
#		"Range": 0,
#		"Splash_damage_range": 0,
#		"SpLash_damage": 0,
#		"Ammo_needed": true,
#		"Speed_change": 0,
#		"StackSize": 1,
#		"Description": "Packs quite a punch, but fires slowly."
#	},
#
#	"Blowpipe": {
#		"ItemCategory": "darts",
#		"Damage": 2,
#		"Attack_speed": 8,
#		"Attack_type": "Ranged",
#		"Range_type": "Infinite",
#		"Range": 0,
#		"Splash_damage_range": 0,
#		"SpLash_damage": 0,
#		"Ammo_needed": true,
#		"Speed_change": 0,
#		"StackSize": 1,
#		"Description": "Packs quite a punch, but fires slowly."
#	},
#
#
#
#	"Normal_arrow": {
#		"ItemCategory": "arrow",
##		"Damage_change": 0,
##		"Poison": 0,
##		"Bleed": 0,
##		"Slow_enemy": 0,
#		"StackSize": 20,
#		"Description": "Ammunition for bows."
#	},
#	"Dart": {
#		"ItemCategory": "dart",
##		"Damage_change": 0,
##		"Poison": 0,
##		"Bleed": 0,
##		"Slow_enemy": 0,
#		"StackSize": 40,
#		"Description": "Ammunition for blowpipe."
#	},




##########################################################
###################### Healing############################
##########################################################
	"Grape": {
		"ItemCategory": "health_potion",
		"Rarity": 1,
		"HP_healed": 1,
		"StackSize": 20,
	},
	"Apple": {
		"ItemCategory": "health_potion",
		"Rarity": 2,
		"HP_healed": 5,
		"StackSize": 15,
	},
	"Pomegranate": {
		"ItemCategory": "health_potion",
		"Rarity": 3,
		"HP_healed": 10,
		"StackSize": 10,
	},
	"Nectar": {
		"ItemCategory": "health_potion",
		"Rarity": 5,
		"HP_healed": 40,
		"StackSize": 5,
	},

##########################################################
################ temporary statt buffs ###################
##########################################################
	"Speed_potion": {
		"ItemCategory": "potion",
		"Rarity": 4,
		"Duration": 10,
		"Speed": +3,
		"Damage": +0,
		"Attack_speed": +2,
		"Infinite_ammo": false,
		"Invisibility": false,
		"StackSize": 5,
		"Description": "Everything seems slow compared to this."
	},
	"Strength_potion": {
		"ItemCategory": "potion",
		"Rarity": 4,
		"Duration": 10,
		"Speed": 0,
		"Damage": +3,
		"Attack_speed": +0,
		"Infinite_ammo": false,
		"Invisibility": false,
		"StackSize": 5,
		"Description": "Everything seems slow compared to this."
	},
	"Attack_speed_potion": {
		"ItemCategory": "potion",
		"Rarity": 4,
		"Duration": 10,
		"Speed": 0,
		"Damage": +0,
		"Attack_speed": +3,
		"Infinite_ammo": false,
		"Invisibility": false,
		"StackSize": 5,
		"Description": "Everything seems slow compared to this."
	},
#	"Potion_of_plenty": {
#		"ItemCategory": "potion",
#		"HP_healed": 0,
#		"Duration": 10,
#		"Speed": 0,
#		"Damage": +0,
#		"Attack_speed": +0,
#		"Infinite_ammo": true,
#		"Invisibility": false,
#		"StackSize": 1,
#		"Description": "Get out of a pinch ammo get's low."
#	},
#	"Invisibility_potion": {
#		"ItemCategory": "potion",
#		"Rarity": 1,
#		"Duration": 3,
#		"Speed": 0,
#		"Damage": +0,
#		"Attack_speed": +0,
#		"Infinite_ammo": false,
#		"Invisibility": true,
#		"StackSize": 10,
#		"Description": "Dissapear into the void."
#	},

##########################################################
############### Permanent statt buffs ####################
##########################################################
	"Max_health_potion": {
		"ItemCategory": "permanent_stat_increase",
		"Rarity": 4,
		"Max_HP": +3,
		"Speed": +0,
		"Damage": +0,
		"Attack_speed": +0,
		"StackSize": 1,
		"Description": "."
	},
	"Max_speed_potion": {
		"ItemCategory": "permanent_stat_increase",
		"Rarity": 4,
		"Max_HP": +0,
		"Speed": +1,
		"Damage": +0,
		"Attack_speed": +0,
		"StackSize": 10,
		"Description": "."
	},
	"Max_strength_potion": {
		"ItemCategory": "permanent_stat_increase",
		"Rarity": 4,
		"Max_HP": +0,
		"Speed": +0,
		"Damage": +1,
		"Attack_speed": +0,
		"StackSize": 10,
		"Description": "."
	},
	"Max_attack_speed_potion": {
		"ItemCategory": "permanent_stat_increase",
		"Rarity": 4,
		"Max_HP": +0,
		"Speed": +0,
		"Damage": +0,
		"Attack_speed": +1,
		"StackSize": 1,
		"Description": "."
	},

	"Lion_hide": {
		"StackSize": 1,
		"ItemCategory": "lion_hide",
		"Rarity": 0,
		"Defence": 1,
		}


##########################################################
######################### MONEY ##########################
##########################################################
#	"Coin": {
#		"ItemCategory": "Money",
#		"Value": 1,
#		"StackSize": 999,
#		"Description": "Looks shiny."
#	},


##########################################################
######################### ARMOR ##########################
##########################################################
#	"Leather_helmet": {
#		"ItemCategory": "Helmet",
#		"Armor": 3,	# Percentage less damage.
#		"Speed": +0,
#		"StackSize": 1,
#		"Description": "Better than nothing."
#	},
#	"Iron_helmet": {
#		"ItemCategory": "Helmet",
#		"Armor": 5,	# Percentage less damage.
#		"Speed": +0,
#		"StackSize": 1,
#		"Description": "Helpfull to keep your head a bit safer."
#	},
#	"Obsidian_helmet": {
#		"ItemCategory": "Helmet",
#		"Armor": 8,	# Percentage less damage.
#		"Speed": +0,
#		"StackSize": 1,
#		"Description": "Looks impenetrable."
#	},
#	"Aerodynamic_helmet": {
#		"ItemCategory": "Helmet",
#		"Armor": 3,	# Percentage less damage.
#		"Speed": +1,
#		"StackSize": 1,
#		"Description": "You can feel the wind blow through your hair."
#	},
#	"Lead_helmet": {
#		"ItemCategory": "Pants",
#		"Armor": 10,	# Percentage less damage.
#		"Speed": -2,
#		"StackSize": 1,
#		"Description": "Wearing this you'll have a heavy head."
#	},
#
#	"Leather_tunic": {
#		"ItemCategory": "Chest_plate",
#		"Armor": 3,	# Percentage less damage.
#		"Speed": +0,
#		"StackSize": 1,
#		"Description": "Hopefully it helps."
#	},
#	"Iron_chest_plate": {
#		"ItemCategory": "Chest_plate",
#		"Armor": 5,	# Percentage less damage.
#		"Speed": +0,
#		"StackSize": 1,
#		"Description": "Can slow down a sword when in need."
#	},
#	"Obsidian_chest_plate": {
#		"ItemCategory": "Chest_plate",
#		"Armor": 8,	# Percentage less damage.
#		"Speed": +0,
#		"StackSize": 1,
#		"Description": "Nothing will get through this."
#	},
#	"T-shirt": {
#		"ItemCategory": "Chest_plate",
#		"Armor": 3,	# Percentage less damage.
#		"Speed": +1,
#		"StackSize": 1,
#		"Description": "Some casual clothing."
#	},
#	"Lead_chest_plate": {
#		"ItemCategory": "Chest_plate",
#		"Armor": 10,	# Percentage less damage.
#		"Speed": -2,
#		"StackSize": 1,
#		"Description": "Heavy, but very protective."
#	},
#
#	"Leather_pants": {
#		"ItemCategory": "Pants",
#		"Armor": 3,	# Percentage less damage.
#		"Speed": +0,
#		"StackSize": 1,
#		"Description": "Doesn't feel really secure."
#	},
#	"Iron_pants": {
#		"ItemCategory": "Pants",
#		"Armor": 5,	# Percentage less damage.
#		"Speed": +0,
#		"StackSize": 1,
#		"Description": "To protect  your privates."
#	},
#	"Obsidian_pants": {
#		"ItemCategory": "Pants",
#		"Armor": 8,	# Percentage less damage.
#		"Speed": +0,
#		"StackSize": 1,
#		"Description": "Not super comfortable."
#	},
#	"Jogging_pants": {
#		"ItemCategory": "Pants",
#		"Armor": 3,	# Percentage less damage.
#		"Speed": +1,
#		"StackSize": 1,
#		"Description": "Is nice and loose."
#	},
#	"Lead_pants": {
#		"ItemCategory": "Pants",
#		"Armor": 10,	# Percentage less damage.
#		"Speed": -2,
#		"StackSize": 1,
#		"Description": "Just hope these pants won't drop down."
#	},
#
#	"Sandals": {
#		"ItemCategory": "Shoes",
#		"Armor": 3,	# Percentage less damage.
#		"Speed": +0,
#		"StackSize": 1,
#		"Description": "hopefully nobody wil step on your toes."
#	},
#	"Iron_shoes": {
#		"ItemCategory": "Shoes",
#		"Armor": 5,	# Percentage less damage.
#		"Speed": +0,
#		"StackSize": 1,
#		"Description": "Will prevent you from losing any toes."
#	},
#	"Obsidian_boots": {
#		"ItemCategory": "Shoes",
#		"Armor": 8,	# Percentage less damage.
#		"Speed": +0,
#		"StackSize": 1,
#		"Description": "Looks sturdy."
#	},
#	"Sneakers": {
#		"ItemCategory": "Shoes",
#		"Armor": 3,	# Percentage less damage.
#		"Speed": +1,
#		"StackSize": 1,
#		"Description": "Run like the wind."
#	},
#	"Lead_boots": {
#		"ItemCategory": "Shoes",
#		"Armor": 10,	# Percentage less damage.
#		"Speed": -2,
#		"StackSize": 1,
#		"Description": "Don't drag your feet to much."
#	}
#}
}
