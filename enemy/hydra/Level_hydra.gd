extends "res://levels/Level.gd"

func _ready():
	GlobalVars.level_counter += 1
	challenge_counter = 3
	rng.randomize()
	GlobalVars.connect("challenge_down", self, "_on_challenge_down")

	if GlobalVars.level_type == "boss":
		spawn_enemies()
	elif GlobalVars.level_type == "loot":
		spawn_chests()
	Player.position = $PlayerSpawn.position
	timer.connect("timeout",self,"enable_styx")
	timer.wait_time = 1
	timer.one_shot = true
	add_child(timer)
	timer.start()
