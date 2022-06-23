extends "res://character/character.gd"

enum states {PATROL, CHASE, ATTACK, KNOCKBACK, DEAD}

var state = states.PATROL
var time = 1
var screen_size
var velocity = Vector2()
var knockback = Vector2.ZERO

var path: Array = []
var levelNavigation: Navigation2D = null

onready var player = get_node("../Player")


# Called when the node enters the scene tree for the first time.
func _ready():
	speed = 4
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
	if health == 0:
		state = states.DEAD
	match state:
		states.DEAD:
			time -= delta

"""
Chooses the right state at the right moment:
- Dead: the sprite flickers and then gets removed from the queue.
- Patrol: the sprite waits for the player to enter the range.
- Attack: Sprite doesn't move when attacking, gets thrown back.
- Knockback: Enemy gets knocked back, then goes back to chasing.
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
		states.ATTACK:
			velocity = Vector2.ZERO
			state = states.KNOCKBACK
		states.CHASE:
			""" Weer tileset"""
			if player and levelNavigation:
				generate_path()
				navigate()
#			var player_direction = (Player.get_position() - self.position).normalized()
#			velocity = position.direction_to(Player.position) * speed
		states.KNOCKBACK:
			var player_direction = (Player.get_position() - self.position).normalized()
			velocity = position.direction_to(Player.position) * -200

func _on_Range_body_entered(body):
	state = states.CHASE

func _on_Player_hit(amount):
	do_damage(amount)
	print("Enemy health", health)

"""
Functies voor pathfinding zodat het niet achter bosjes blijft zitten, kan pas met nieuwe tileset.
"""
func navigate():	# Define the next position to go to
	if path.size() > 0:
		velocity = global_position.direction_to(path[1]) * speed

	# If the destination is reached, remove this path from the array
	if global_position == path[0]:
		path.pop_front()

func generate_path():	# It generates the path
	if levelNavigation != null and player != null:
		path = levelNavigation.get_simple_path(global_position, player.global_position, false)
