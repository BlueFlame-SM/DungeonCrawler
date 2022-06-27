extends Node

var level_type = "start"

var level_counter = 0

signal challenge_down()

func challenge_down():
	emit_signal("challenge_down")
