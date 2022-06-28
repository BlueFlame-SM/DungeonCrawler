extends "res://character/character.gd"

enum states {PATROL, FIRE, DEAD, CHASE}

const BULLET := preload("res://bullet/bullet.tscn")

var state = states.PATROL
var time = 1
var screen_size
var velocity = Vector2()
var knockback = Vector2.ZERO
var fire = false

onready var timer = $Timer
var fire_counter = 0

var path: Array = []
var levelNavigation: Navigation2D = null

#Lijkt me niet nodig want global
onready var player = get_node("../Player")

# Called when the node enters the scene tree for the first time.
func _ready():
	self._set_temp_speed(4)
	screen_size = get_viewport_rect().size
	"""Kan pas met nieuwe tileset, laten staan!!!"""
	yield(get_tree(), "idle_frame")
	var tree = get_tree()
	if tree.has_group("LevelNavigation"):
		levelNavigation = tree.get_nodes_in_group("LevelNavigation")[0]
	if tree.has_group("Player"):
		player = tree.get_nodes_in_group("Player")[0]

func _physics_process(delta):
	choose_action()
	velocity = move_and_slide(move_in_direction(velocity))
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	if abs(velocity.x) - abs(velocity.y) > 10:
		if velocity.x > 0:
			print(true)
			$AnimatedSprite.animation = "zombie_left"
			$AnimatedSprite.flip_h = true
		elif velocity.x < 0:
			$AnimatedSprite.animation = "zombie_left"
			$AnimatedSprite.flip_h = false
	else:
		if velocity.y > 0:
			$AnimatedSprite.animation = "zombie_down"
			$AnimatedSprite.flip_h = false
		elif velocity.y < 0:
			$AnimatedSprite.animation = "zombie_up"
			$AnimatedSprite.flip_h = false


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
				GlobalVars.challenge_down("enemy", self.position)
				set_physics_process(false)
				queue_free()
		states.PATROL:
			velocity = Vector2.ZERO
		states.FIRE:
			velocity = Vector2.ZERO
			pass
		states.CHASE:
			""" Weer tileset"""
			if player and levelNavigation:
				generate_path()
				navigate()

func _on_Range_body_entered(body):
	state = states.CHASE

func _on_FiringRange_body_entered(body):
	state = states.FIRE

#	if fire_counter == 0:
#		fire()
	fire()

	fire = true
	timer.start(0)

func _on_FiringRange_body_exited(body):
	state = states.CHASE
	fire = false

#	fire_counter = 1
	timer.stop()

func _on_Timer_timeout():
#	if fire_counter == 1:
#		fire_counter = 0
##		timer.stop()
	if fire != false:
		fire()


func fire():
	var bullet = BULLET.instance()
	bullet.init(position, position.direction_to(Player.position) * 200, 2)
	get_parent().add_child(bullet)


"""
Functies voor pathfinding zodat het niet achter bosjes blijft zitten, kan pas met nieuwe tileset.
"""
func navigate():	# Define the next position to go to
	if path.size() > 0:
		velocity = global_position.direction_to(path[1]) * self._get_temp_speed()

	# If the destination is reached, remove this path from the array
	if global_position == path[0]:
		path.pop_front()

# Generates a path to the player.
func generate_path():
	if levelNavigation != null and player != null:
		path = levelNavigation.get_simple_path(global_position, player.global_position, false)
