extends Node2D

export (String) var level_name = "level"

var timer = Timer.new()


func enable_styx():
	if $Styx/CollisionPolygon2D:
		$Styx/CollisionPolygon2D.disabled = false


# Called when the node enters the scene tree for the first time.
func _ready():
	Player.position = $PlayerSpawn.position
	Player.can_move = true
	timer.connect("timeout",self,"enable_styx")
	timer.wait_time = 1
	timer.one_shot = true
	add_child(timer)
	timer.start()

func _on_Styx_body_entered(body):
#	print(Player/CollisionShape2D.disabled)
	if body.name == "Player":
		Player.die()
