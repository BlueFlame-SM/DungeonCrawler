class_name Bullet
extends Area2D

var velocity = Vector2(0, 200)
var damage = 1


func init(pos:Vector2=position, vel:Vector2=velocity, dmg:int=damage):
	"""
	Initializes a bullet.

	Parameters
	----------
	pos: Vector2, default=Vector2.ZERO
		The initial position of the bullet.
	vel: Vector2, default=Vector2(0,200)
		The velocity of the bullet.
	dmg: int, default = 1
		The amount of damage dealt on hit.
	"""
	position = pos
	velocity = vel
	damage = max(0, dmg)
	return self


func _physics_process(delta):
	position += velocity * delta


func _on_Bullet_body_entered(body):
	if body == Player:
		Player.health -= damage
	queue_free()
