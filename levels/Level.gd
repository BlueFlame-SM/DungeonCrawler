extends Node2D

var timer = Timer.new()
var challenge_counter = 0
signal gates_open()
var rng = RandomNumberGenerator.new()
var river = false

"""
To prevent players from getting damage from the styx when a new level starts,
due to the styx loading earlier than the player getting repositioned at the
start gate, the styx only does damage when this function is called. This function
is called after a timer. Also enables enemy. Rename function to more general
"""
func enable_styx():
	if $River_collision:
		for child in $River_collision.get_children():
			child.disabled = false
	Player.can_move = true
	if GlobalVars.level_type == "start":
		GlobalVars.reset()
		GlobalVars.level_counter = 1
	elif GlobalVars.level_type in ["loot", "boss", "preboss", "bigboss", "endboss"]:
		GlobalVars.level_counter += 1

# Called when the node enters the scene tree for the first time.
func _ready():
#	Count how many levels the player has played from start level
	rng.randomize()
#	Connect the signal from GlobalVars to function
	GlobalVars.connect("challenge_down", self, "_on_challenge_down")
#	Depending on level type, spawn appropriate instances
	if GlobalVars.level_type in "boss":
		spawn_enemies()
	elif GlobalVars.level_type == "loot":
		spawn_chests()
#	Set the global player at the start position near the entering gate
	Player.position = $PlayerSpawn.position
#	Wait a second to enable styx collision box
	timer.connect("timeout",self,"enable_styx")
	timer.wait_time = 0.8
	timer.one_shot = true
	add_child(timer)
	timer.start()

func _physics_process(delta):
	if river == true:
		Player.do_damage(1)


"""
Spawns one enemy in a level at a random position out of 4 possible positions.
Spawns either a range or normal enemy. Can be extended to other types.
"""
func spawn_enemies():
	var amount = rng.randi_range(1, 4)
	for i in amount:
		var enemy_type
		if rng.randf_range(0, 1) < 0.5:
			enemy_type = load("res://enemy_range/enemy_range.tscn")
		else:
			enemy_type = load("res://enemy/enemy.tscn")
		var enemy
		enemy = enemy_type.instance()
		var spawn_point = $EnemySpawns.get_children()[i]
		enemy.position = spawn_point.position
		add_child(enemy)
		enemy_difficulties(enemy)
		challenge_counter += 1

func spawn_reward(item, pos):
	if typeof(item) == TYPE_STRING:
		var scene = load("res://floor_item/floor_item.tscn")
		var instance = scene.instance()
		instance.item_name = item
		instance.position = pos
		var broom = add_child(instance)

"""
Generates dictionary with for each rarity which items belong to it.
"""
func item_rarity():
	var dict_rarity = {}
	for key in JsonData.item_data.keys():
		if JsonData.item_data[key]["Rarity"] in dict_rarity:
			dict_rarity[JsonData.item_data[key]["Rarity"]].append(key)
		else:
			dict_rarity[JsonData.item_data[key]["Rarity"]] = [key]

	return dict_rarity


"""
Spawns a chest in a level at a random position out of 4 possible positions.
"""
func spawn_chests():

	var chest = load("res://chest/Chest.tscn").instance()

	var spawn_point = $EnemySpawns.get_children()[randi() % 4]
	chest.position = spawn_point.position
	var max_idx = JsonData.item_data.keys().size() - 1

	var dict_rarity = item_rarity()
	var chosen_items = []
	# A random rarity is chosen, and from that rarity a random item.
	for i in range(5):
		randomize()
		var num = rng.randi_range(1, 19)
		if num < 9:
			randomize()
			chosen_items.append(dict_rarity[1][randi() % dict_rarity[1].size() - 1])
		elif num < 14:
			randomize()
			chosen_items.append(dict_rarity[2][randi() % dict_rarity[2].size() - 1])
		elif num < 17:
			randomize()
			chosen_items.append(dict_rarity[3][randi() % dict_rarity[3].size() - 1])
		elif num < 19:
			randomize()
			chosen_items.append(dict_rarity[4][randi() % dict_rarity[4].size() - 1])
		else:
			randomize()
			chosen_items.append(dict_rarity[5][randi() % dict_rarity[5].size() - 1])

	chest.choose_items(chosen_items)
	add_child(chest)

	#	This becomes relevant if you want to spawn more than 1 chest. Not currently implemented.
	challenge_counter += 1

func random_item(dict_rarity, num):
	if num < 10:
		randomize()
		return dict_rarity[1][randi() % dict_rarity[1].size() - 1]
	elif num < 15:
		randomize()
		return dict_rarity[2][randi() % dict_rarity[2].size() - 1]
	elif num < 19:
		randomize()
		return dict_rarity[3][randi() % dict_rarity[3].size() - 1]
	elif num < 22:
		randomize()
		return dict_rarity[4][randi() % dict_rarity[4].size() - 1]
	else:
		randomize()
		return dict_rarity[5][randi() % dict_rarity[5].size() - 1]

"""
If the player collides with the styx collision box this function is called.
The damage is done to display the decline of health on the health bar.
The player then dies.
"""
func _on_River_collision_body_entered(body):
	if body.name == "Player":
		river = true

"""
This function is called when a challenge to the player is overcome. Possible
challenges are killing enemies or opening chests. When all tasks are completed
the challenge counter is 0 and the function or level_completed is called.
"""
func _on_challenge_down(type, pos):
	challenge_counter -= 1
	var dict_rarity = item_rarity()
	if type == "enemy":
		randomize()
		var num = rng.randi_range(1, 24)
		spawn_reward(random_item(dict_rarity, num), pos)
	if challenge_counter <= 0:
#		Because of this code, be wary of spawning both a chest and enemy at once
#	Needs to be rewritten to support this implementation.
		if type == "hydra":
			pos = Vector2(Player.position.x, Player.position.y - 5)
			randomize()
			var num = rng.randi_range(17, 19)
			spawn_reward(random_item(dict_rarity, num), pos)
		if type == "lion":
			pos = Vector2(Player.position.x, Player.position.y - 5)
			spawn_reward("Lion_hide", pos)
		if type == "cerberus":
			$DeadCerberus.visible = true
#			We should spawn something, maybe play a sound?
			pass
		level_completed()

"""
When the level is completed the signal "gates_open" is emitted to make the
gates behave like theyre open. LevelNavigation/Gates_open makes the gate visually
appear open.
"""
func level_completed():
	emit_signal("gates_open")
	$LevelNavigation/Gates_open.visible = true


"""Function to increase the stats of enemies each 5 levels."""
func enemy_difficulties(enemy):
	if GlobalVars.level_counter % 5:
		enemy._set_perm_damage(enemy._get_perm_damage() + 1)
	if GlobalVars.level_counter == 1:
		enemy._set_perm_damage(GlobalVars.dmg_reset)


func _on_River_collision_body_exited(body):
	if body == Player:
		river = false
