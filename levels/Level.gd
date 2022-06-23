extends Node2D

export (String) var level_name = "level"

var timer = Timer.new()

signal gates_open()

func enable_styx():
	if $River_collision:
		for child in $River_collision.get_children():
			child.disabled = false



# Called when the node enters the scene tree for the first time.
func _ready():
	if GlobalVars.level_type == "boss":
		spawn_enemies()
	Player.position = $PlayerSpawn.position
	Player.can_move = true
	timer.connect("timeout",self,"enable_styx")
	timer.wait_time = 2
	timer.one_shot = true
	add_child(timer)
	timer.start()

func spawn_enemies():
	print("spawning enemy")
	var enemy = load("res://enemy/enemy.tscn").instance()
	enemy.position = $EnemySpawn.position
	add_child(enemy)

func spawn_chests():
	pass


func _on_River_collision_body_entered(body):
	if body.name == "Player":
		Player.die()

#This function should be called when the enemy is defeated. This should signal
#from enemy class.
func _on_LevelCompleted_pressed():
	emit_signal("gates_open")
	$Gates_open.visible = true
	pass # Replace with function body.
