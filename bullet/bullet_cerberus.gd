extends Bullet
"""
A bullet fired by Cerberus.
Requires the bullet to be rotated in the correct direction.

Functions
---------
- _ready:
	Called when the node enters the scene tree.
- _on_bullet_cerberus_body_entered:
	Called when a body enters the bullet.
"""

func _ready():
	"""
	Called when the node enters the scene tree.
	Rotates the bullet in orientation of velocity.
	"""
	var rotation = rad2deg(acos(velocity.normalized().dot(Vector2.RIGHT)))
	rotation_degrees = rotation + 180
