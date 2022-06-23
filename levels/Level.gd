extends Node2D

export (String) var level_name = "level"

var timer = Timer.new()


func enable_styx():
	if $River_collision:
		for child in $River_collision.get_children():
			child.disabled = false


# Called when the node enters the scene tree for the first time.
func _ready():
	Player.position = $PlayerSpawn.position
	Player.can_move = true
	timer.connect("timeout",self,"enable_styx")
	timer.wait_time = 2
	timer.one_shot = true
	add_child(timer)
	timer.start()


func _on_gate_opens():
	$Gates_open.visible = true


func _on_River_collision_body_entered(body):
	if body.name == "Player":
		Player.die()

