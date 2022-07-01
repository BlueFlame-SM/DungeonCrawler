"""
	Script for the hotbar.
"""

extends Node2D

# Signal to update the hotbar.
signal inventory_updated

func _ready():
	# Emit the signal to update the hotbar.
	emit_signal("inventory_updated")
