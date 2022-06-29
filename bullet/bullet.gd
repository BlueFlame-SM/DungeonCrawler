extends Area2D
class_name Bullet

var velocity = Vector2(0, 200)
var damage = 1
#
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

	Returns
	-------
	self: Bullet
		The self instance, useful for chaining calls.
	"""
	position = pos
	velocity = vel
	damage = max(0, dmg)
	return self

#
#func _physics_process(delta):
#	position += velocity * delta
#
#"""


var move = Vector2.ZERO
var look_vec = Vector2.ZERO
var speed = 3


func _ready():
	look_vec = Player.position - global_position


func _physics_process(delta):
	move = Vector2.ZERO

	move = move.move_toward(look_vec, delta)
	move = move.normalized() * speed
	position += move

"""TODO!"""
func _on_Bullet_body_entered(body):
	if body == Player:
		print("bullet entered")
		Player.hurt()
		#TODO: hardcode weghalen
		Player.health -= 2
	queue_free()

#When a bullet hits a body, we want to remove it from the world.
#This is done by calling the remove_body function.
#"""
#func _on_Bullet_body_entered(body):
#
#	if body == Player:
#		Player.health -= damage
#	queue_free()
#
#
