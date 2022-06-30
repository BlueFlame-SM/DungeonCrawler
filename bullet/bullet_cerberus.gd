extends Bullet


func _ready():
	speed = 5
	
	# Rotate bullet scene so that is points to the player.
	var start_dir = Vector2(1, 0)
	var rotation = rad2deg(acos(velocity.normalized().dot(start_dir)))
	rotation_degrees = rotation + 180


func _on_bullet_cerberus_body_entered(body):
	""" Do damge to player once it enters the player body. """
	if body == Player:
		Player.hurt()
		Player.do_damage(damage)
	queue_free()
