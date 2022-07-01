"""
	This program implents random items that spawn on the floor.

	Source used: https://github.com/arkeve/Godot-Inventory-System/tree/lootable-items
"""



class_name FloorItem
extends RigidBody2D


var player = null
var picked_up = false
export var item_name: String
var options = JsonData.item_data.keys()

func _ready():
	$AnimatedSprite.animation = item_name


func _physics_process(delta):
	if picked_up == true:
		if self.scale.x > 0:
			self.scale.x -= 0.15
			self.scale.y -= 0.15

		if self.scale.x < 0.2:
			PlayerInventory.add_item(item_name, 1)
			queue_free()


func pick_up_item(body):
	player = body
	picked_up = true