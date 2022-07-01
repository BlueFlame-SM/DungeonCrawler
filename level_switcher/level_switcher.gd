"""
	This implements a level switcher so players can switch levels.
	It is a simple script that can be added to any level.
	It will switch to the next level when the player reaches the end of the level.
	It will also switch to the previous level when the player reaches the start of the level.

	Sources:
		https://github.com/dirkk0/godot-scene-transition/blob/main/global/global.gd
		https://docs.godotengine.org/en/stable/tutorials/scripting/singletons_autoload.html
"""



extends Node

var followingScene = ""
var currentScene = ""

var timer = Timer.new()
onready var player = $AnimationPlayer
signal anim_finished


func _ready():
	var root = get_tree().get_root()
	currentScene = root.get_child(root.get_child_count() - 1)


func goto_scene(path, dead=false):
	"""
		This function will switch to the scene specified by the path.
		If dead is true, the scene will be switched to after the current scene has finished.
	"""
	LevelSwitcher.followingScene = path
	player.playback_speed = 1
	if !dead:
		player.play("fade")
	else:
		pass
		player.play("die")


func _deferred_goto_scene(path):
	"""
		This function will switch to the scene specified by the path.
		It will be called after the current scene has finished.
	"""
	# It is now safe to remove the current scene
	currentScene.free()

	# Load the new scene.
	var s = ResourceLoader.load(path)
	player.play_backwards()

	# Instance the new scene.
	currentScene = s.instance()

	# Add it to the active scene, as child of root.
	get_tree().get_root().add_child(currentScene)

	# Plays sound on level enter. not for commercial use ( check)
	#	https://freesound.org/people/InspectorJ/sounds/431118/
	if GlobalVars.level_type != "start" and GlobalVars.level_type != "game_over":
		$door_shuts.play()


func _on_AnimationPlayer_animation_finished(anim_name):
	"""
		This function is called when the animation has finished.
		It will switch to the next scene if the current scene is the last one.
		It will switch to the previous scene if the current scene is the first one.
	"""
	emit_signal("anim_finished")

	if LevelSwitcher.followingScene != "":
		call_deferred("_deferred_goto_scene", LevelSwitcher.followingScene)
	LevelSwitcher.followingScene = ""

	if GlobalVars.level_type == "start":
		Gui.get_child(0).show()
		Player.show()
		Player.get_child(4).get_child(1).show()
