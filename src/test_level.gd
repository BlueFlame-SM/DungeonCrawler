extends Node2D


func _on_Player_character_died():
	$Player.queue_free()
