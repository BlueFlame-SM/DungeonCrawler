extends Node2D


func _ready():
	Player.position = $PlayerSpawn.position


func _on_Button_pressed():
	SceneSwitcher.goto_scene("res://levels/test_level_2.tscn")
