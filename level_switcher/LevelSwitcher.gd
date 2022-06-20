#Sources:
#	https://github.com/dirkk0/godot-scene-transition/blob/main/global/global.gd
#	https://docs.godotengine.org/en/stable/tutorials/scripting/singletons_autoload.html
extends Node

var followingScene = ""
var currentScene = ""

onready var player = $AnimationPlayer
func _ready():
	var root = get_tree().get_root()
	currentScene = root.get_child(root.get_child_count() - 1)



func goto_scene(path, dead=false):
	print(path)
	LevelSwitcher.followingScene = path
	player.playback_speed = 1
	if !dead:
		player.play("fade")
	else:
		player.play("die")


func _deferred_goto_scene(path):
	print(path)
	get_tree().change_scene(path)

	# It is now safe to remove the current scene
	currentScene.free()

	# Load the new scene.
	var s = ResourceLoader.load(path)

	# Instance the new scene.
	currentScene = s.instance()

	# Add it to the active scene, as child of root.
	get_tree().get_root().add_child(currentScene)

	# Optionally, to make it compatible with the SceneTree.change_scene() API.
#	get_tree().set_current_scene(currentScene)

	player.play_backwards()
	# Plays sound on level enter. not for commercial use ( check)
	#	https://freesound.org/people/InspectorJ/sounds/431118/
	$door_shuts.play()


func _on_AnimationPlayer_animation_finished(anim_name):
	if LevelSwitcher.followingScene != "":
		call_deferred("_deferred_goto_scene", LevelSwitcher.followingScene)
	LevelSwitcher.followingScene = ""
