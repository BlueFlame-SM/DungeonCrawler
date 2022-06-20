extends Node2D

export (String) var level_name = "level"


# Called when the node enters the scene tree for the first time.
func _ready():
	Player.position = $PlayerSpawn.position
	Player.can_move = true


func _on_Styx_body_entered(body):
	Player.die()
