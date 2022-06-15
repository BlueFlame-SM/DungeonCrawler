extends Node2D


func _on_Player_character_died():
	$Player.queue_free()


func _on_Button_pressed():
	SceneSwitcher.goto_scene("res://levels/test_level_2.tscn")
