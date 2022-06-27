#extends Node2D

extends "res://levels/Level.gd"

#export (String) var level_name = "level"

#var timer = Timer.new()
#var challenge_counter = 0
#signal gates_open()
#var rng = RandomNumberGenerator.new()

#func enable_styx():
#	if $River_collision:
#		for child in $River_collision.get_children():
#			child.disabled = false
#	Player.can_move = true



# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalVars.level_counter += 1
	challenge_counter = 3
	rng.randomize()
	GlobalVars.connect("challenge_down", self, "_on_challenge_down")

	if GlobalVars.level_type == "boss":
		spawn_enemies()
	elif GlobalVars.level_type == "loot":
		spawn_chests()
	elif GlobalVars.level_type == "start":
		Player._set_health(10)
	Player.position = $PlayerSpawn.position
	timer.connect("timeout",self,"enable_styx")
	timer.wait_time = 1
	timer.one_shot = true
	add_child(timer)
	timer.start()

#func spawn_enemies():
#	print("spawning enemy")
#	var enemy
#	if rng.randf_range(0, 1) < 0.5:
#		enemy = load("res://enemy_range/enemy_range.tscn").instance()
#	else:
#		enemy = load("res://enemy/enemy.tscn").instance()
#	enemy.position = $EnemySpawn.position
#	add_child(enemy)
##	This becomes relevant if you want to spawn more than 1 enemy. Not currently implemented.
#	challenge_counter += 1

#func spawn_chests():
#	print("spawning chest")
#	var chest = load("res://chest/Chest.tscn").instance()
#	chest.position = $EnemySpawn.position
#	add_child(chest)
##	This becomes relevant if you want to spawn more than 1 chest. Not currently implemented.
#	challenge_counter += 1
#
#func _on_River_collision_body_entered(body):
#	if body.name == "Player":
#		Player.do_damage(Player.health)
#		Player.die()
#
#func _on_challenge_down():
#	print("challenge down in level script!")
#	challenge_counter -= 1
#	if challenge_counter <= 0:
#		level_completed()
#
#
#func level_completed():
#	emit_signal("gates_open")
#	$LevelNavigation/Gates_open.visible = true
#
##This function should be called when the enemy is defeated. This should signal
##from enemy class.
#func _on_LevelCompleted_pressed():
#	emit_signal("gates_open")
#	$LevelNavigation/Gates_open.visible = true
