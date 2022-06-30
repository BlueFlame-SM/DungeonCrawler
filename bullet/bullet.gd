class_name Bullet
extends Area2D
"""
A projectile which can be fire from a position with a velocity doing an amount of damage.

Fields
------
+ velocity: Vector2, default=Vector2(0, 200)
	The velocity of the bullet (direction * speed).
+ damage:
	The damage the bullet does on hit.

Functions
---------
- _physics_process
	Called by the engine on each physics update.
- _on_Bullet_body_entered
	Called by the engine when a bullet intersects with a body.
"""

var velocity = Vector2(0, 200)
var damage = 1
#
func init(pos:Vector2=position, vel:Vector2=velocity, dmg:int=damage):
	"""
	Initializes a bullet. Should be called before adding to the scene tree.

	Parameters
	----------
	pos: Vector2, default=Vector2.ZERO
		The initial position of the bullet.
	vel: Vector2, default=Vector2(0,200)
		The velocity of the bullet.
	dmg: int, default = 1
		The amount of damage dealt on hit.

	Returns
	-------
	self: Bullet
		The self instance, useful for chaining calls.
	"""
	position = pos
	velocity = vel
	damage = max(0, dmg)
	return self


func _physics_process(delta):
	"""
	Called on each physics update.
	Moves the bullet in the direction of velocity.

	Parameters
	----------
	delta: float
		The time between physics updates.
	"""
	position += velocity * delta


func _on_Bullet_body_entered(body):
	"""
	Called when another body enters the bullet.
	Removes the bullet and damages the player on player hit.

	Parameters
	----------
	body: Any
		The body that entered the bullet.
	"""
	if body == Player:
		Player.hurt()
		Player.health -= damage
	queue_free()
