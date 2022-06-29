extends "res://character/character.gd"

enum states {PATROL, FIRE, DEAD, CHASE, KNOCKBACK}

const BULLET := preload("res://bullet/bullet.tscn")

var state = states.PATROL
var time = 1
var screen_size
var velocity = Vector2()
var fire = false

onready var timer = $Timer
var fire_counter = 0

onready var timer_knockback = $TimerKnockback

var path: Array = []
var levelNavigation: Navigation2D = null

#Lijkt me niet nodig want global
onready var player = get_node("../Player")

# Called when the node enters the scene tree for the first time.
func _ready():
	self._set_perm_speed(4)
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
	if velocity == Vector2.ZERO:
		if abs(Player.position.y - position.y) > abs(Player.position.x - position.x):
			if Player.position.y - position.y < 0:
				$AnimatedSprite.animation = "zombie_up"
				$AnimatedSprite.flip_h = false
			else:
				$AnimatedSprite.animation = "zombie_down"
				$AnimatedSprite.flip_h = false
		else:
			if Player.position.x - position.x > 0:
				$AnimatedSprite.animation = "zombie_left"
				$AnimatedSprite.flip_h = true
			else:
				$AnimatedSprite.animation = "zombie_left"
				$AnimatedSprite.flip_h = false

	elif abs(velocity.x) - abs(velocity.y) > 5:
		if velocity.x > 0:
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
		states.KNOCKBACK:
			if $TimerKnockback.time_left <= 0:
				velocity = Vector2.ZERO
				timer_knockback.start()

			_knockback_Enemy()

func _knockback_Enemy():
	var player_direction = (Player.get_position() - self.position).normalized()
	velocity = position.direction_to(Player.position) * -200

func _on_TimerKnockback_timeout():
	if fire == true:
		state = states.FIRE
	else:
		state = states.CHASE

# If the player comes in the detection range, the enemy starts chasing the player.
func _on_Range_body_entered(body):
	state = states.CHASE

func _on_FiringRange_body_entered(body):
	state = states.FIRE
	fire()
	fire = true
	timer.start(0)

func _on_FiringRange_body_exited(body):
	if $TimerKnockback.time_left <= 0:
		state = states.CHASE

	fire = false
	timer.stop()

func _on_Timer_timeout():
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
		velocity = global_position.direction_to(path[1]) * (_get_temp_speed() + _get_perm_speed())

	# If the destination is reached, remove this path from the array
	if global_position == path[0]:
		path.pop_front()

# Generates a path to the player.
func generate_path():
	if levelNavigation != null and player != null:
		path = levelNavigation.get_simple_path(global_position, player.global_position, false)
