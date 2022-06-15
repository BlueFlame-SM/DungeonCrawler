#Sources:
#	https://github.com/dirkk0/godot-scene-transition/blob/main/global/global.gd
#	https://docs.godotengine.org/en/stable/tutorials/scripting/singletons_autoload.html
extends Node

var next_scene


func goto_scene(path):
	next_scene = path
	$AnimationPlayer.play("fade_to_black")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "fade_to_black":
		get_tree().change_scene(next_scene)
		$AnimationPlayer.play("fade_to_normal")
	elif anim_name == "fade_to_normal":
		print("transition done")
