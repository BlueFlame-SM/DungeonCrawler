extends Area2D
class_name Bullet


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


func _on_Bullet_body_entered(body):
	if body == Player:
		#TODO: hardcode weghalen
		Player.health -= 2
	print(Player.health)
	queue_free()
