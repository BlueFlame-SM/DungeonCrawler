extends Node2D

export (String) var level_name = "level"

var timer = Timer.new()
var challenge_counter = 0
signal gates_open()
var rng = RandomNumberGenerator.new()


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
#	TODO ix this
	if $Enemy:
		$Enemy/Range/CollisionShape2D.disabled = false
	if GlobalVars.level_type == "start":
		GlobalVars.reset()

# Called when the node enters the scene tree for the first time.
func _ready():
#	Count how many levels the player has played from start level
	GlobalVars.level_counter += 1
	rng.randomize()
#	Connect the signal from GlobalVars to function
	GlobalVars.connect("challenge_down", self, "_on_challenge_down")
#	Depending on level type, spawn appropriate instances
	if GlobalVars.level_type == "boss":
		spawn_enemies()
	elif GlobalVars.level_type == "loot":
		spawn_chests()
#	Set the global player at the start position near the entering gate
	Player.position = $PlayerSpawn.position
#	Wait a second to enable styx collision box
	timer.connect("timeout",self,"enable_styx")
	timer.wait_time = 1
	timer.one_shot = true
	add_child(timer)
	timer.start()
	print(self.name)


"""
Spawns one enemy in a level at a random position out of 4 possible positions.
Spawns either a range or normal enemy. Can be extended to other types.
"""
func spawn_enemies():
	var enemy
	if rng.randf_range(0, 1) < 0.9:
		enemy = load("res://enemy_range/enemy_range.tscn").instance()
	else:
		enemy = load("res://enemy/enemy.tscn").instance()
	var spawn_point = $EnemySpawns.get_children()[randi() % 4]
	enemy.position = spawn_point.position
	add_child(enemy)
	enemy_difficulties(enemy)
#	This becomes relevant if you want to spawn more than 1 enemy. Not currently implemented.
	challenge_counter += 1

"""
Spawns a chest in a level at a random position out of 4 possible positions.
"""
func spawn_chests():
	var chest = load("res://chest/Chest.tscn").instance()
	var spawn_point = $EnemySpawns.get_children()[randi() % 4]
	chest.position = spawn_point.position
	var max_idx = JsonData.item_data.keys().size() - 1
#	Change this to get random ints of max len_keys.
	chest.choose_items([rng.randi_range(0, max_idx), rng.randi_range(0, max_idx),\
	 rng.randi_range(0, max_idx), rng.randi_range(0, max_idx),rng.randi_range(0, max_idx)])
	add_child(chest)
#	This becomes relevant if you want to spawn more than 1 chest. Not currently implemented.
	challenge_counter += 1

"""
If the player collides with the styx collision box this function is called.
The damage is done to display the decline of health on the health bar.
The player then dies.
"""
func _on_River_collision_body_entered(body):
	if body.name == "Player":
		Player.do_damage(Player.health)

"""
This function is called when a challenge to the player is overcome. Possible
challenges are killing enemies or opening chests. When all tasks are completed
the challenge counter is 0 and the function or level_completed is called.
"""
func _on_challenge_down():
	challenge_counter -= 1
	if challenge_counter <= 0:
		level_completed()

"""
When the level is completed the signal "gates_open" is emitted to make the
gates behave like theyre open. LevelNavigation/Gates_open makes the gate visually
appear open.
"""
func level_completed():
	emit_signal("gates_open")
	$LevelNavigation/Gates_open.visible = true


"""Function to increase the stats of enemies when levels increase. """
func enemy_difficulties(enemy):
	if GlobalVars.level_counter == 1:
		enemy._set_damage(2)
	if GlobalVars.level_counter % 2 or GlobalVars.level_counter % 3:
		enemy._set_damage(enemy._get_damage() + 1)
