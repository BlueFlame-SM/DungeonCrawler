extends Node
#
#
#var next_level = null
#onready var current_level = $TestLevel1
#onready var anim = $AnimationPlayer
#signal gate_closing
#
#
## Called when the node enters the scene tree for the first time.
#func _ready():
#	conn()
#
#func conn():
#	current_level.connect("level_changed_to_boss", self, "handle_level_changed_to_boss")
#	current_level.connect("level_changed_to_shop", self, "handle_level_changed_to_shop")
#	current_level.connect("level_changed_to_lootbox", self, "handle_level_changed_to_lootbox")
#
#func handle_level_changed_to_boss(current_level_name: String):
#	var next_level_name: String
#
#	match current_level_name:
#		"level1":
#			next_level_name = "TestLevel2"
#		_:
#			return
##	go_to_next_level(next_level_name)
#
#func handle_level_changed_to_shop(current_level_name: String):
#	var next_level_name: String
#
#	match current_level_name:
#		"level1":
#			next_level_name = "TestLevel3"
#		_:
#			return
#	go_to_next_level(next_level_name)
#
#
#func handle_level_changed_to_lootbox(current_level_name: String):
#	var next_level_name: String
#
#	match current_level_name:
#		"level1":
#			next_level_name = "TestLevel4"
#		_:
#			return
#	go_to_next_level(next_level_name)
#
#func go_to_next_level(next_level_name):
#	next_level = load("res://Test_Mul-Level/" + next_level_name + ".tscn").instance()
#	add_child(next_level)
#	next_level.layer = -1
#	anim.play("fade_in")
##	Is onderstaande nodig of is dit voor het teruggaan?
#	conn()
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
##func _process(delta):
##	pass
#
#
#func _on_AnimationPlayer_animation_finished(anim_name: String):
#	match anim_name:
#		"fade_in":
#			current_level.queue_free()
#			current_level = next_level
#			current_level.layer = 1
##			Set to null as not to store unneeded information. Green
#			next_level = null
#			anim.play("fade_out")
#
#			emit_signal("gate_closing")
##		not implemented
#		"fade_out":
#			pass
