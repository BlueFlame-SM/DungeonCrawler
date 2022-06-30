extends Bullet


func _ready():
	# Rotate bullet scene so that is points to the player.
	var rotation = rad2deg(acos(velocity.normalized().dot(Vector2.RIGHT)))
	rotation_degrees = rotation + 180


func _on_bullet_cerberus_body_entered(body):
	""" Do damge to player once it enters the player body. """
	if body == Player:
		Player.hurt()
		Player.do_damage(damage)
	queue_free()
