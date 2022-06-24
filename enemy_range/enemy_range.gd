
extends "res://character/character.gd"

enum states {PATROL, FIRE, DEAD}

var state = states.PATROL
var time = 1
var screen_size
var velocity = Vector2()
var knockback = Vector2.ZERO
var fire = null

onready var timer = $Timer

var path: Array = []
var levelNavigation: Navigation2D = null

#Lijkt me niet nodig want global
onready var player = get_node("../Player")
onready var BULLET_SCENE = preload("res://bullet/bullet.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size

func _physics_process(delta):
	choose_action()
	velocity = move_and_slide(move_and_slide(move_in_direction(velocity)))
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	if health == 0:
		state = states.DEAD
	match state:
		states.DEAD:
			time -= delta

"""
Chooses the right state at the right moment:
- Dead: the sprite flickers and then gets removed from the queue.
- Patrol: the sprite waits for the player to enter the range.
- Fire: the sprite fires every n frames a bullet at the player.
"""
func choose_action():
	match state:
		states.DEAD:
			velocity = Vector2.ZERO
			if time > 0:
				self.modulate.a = 0 if Engine.get_frames_drawn() % 5 == 0 else 1.0
			else:
				set_physics_process(false)
				queue_free()
		states.PATROL:
			velocity = Vector2.ZERO
		states.FIRE:
			pass

func _on_Range_body_entered(body):
	fire = true
	timer.start(0)


func fire():
	var bullet = BULLET_SCENE.instance()
	bullet.position = get_global_position()
	get_parent().add_child(bullet)


func _on_Timer_timeout():
	if fire != null:
		fire()


