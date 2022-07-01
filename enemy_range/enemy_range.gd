"""
	Script for the enemy ranged.
	This script is used to control the enemy.
	It is used to move the enemy, shoot at the player
	and to detect if the enemy is hit by the player.

	This video was used for the pathfinding.
	https://www.youtube.com/watch?v=gFlGMLmg8yg
"""

extends "res://character/character.gd"

enum states {PATROL, FIRE, DEAD, CHASE, KNOCKBACK}

const BULLET := preload("res://bullet/bullet.tscn")

var state = states.PATROL
var time = 1
var screen_size
var velocity = Vector2()
var fire = false

# For fire timer.
onready var timer = $Timer
var fire_counter = 0

onready var timer_knockback = $TimerKnockback

var path: Array = []
var levelNavigation: Navigation2D = null

onready var player = get_node("../Player")

# Called when the node enters the scene tree for the first time.
func _ready():
	"""
		This function is called when the entity is ready.
		It is called only once.
	"""
	# Set speed of entity.
	self._set_perm_speed(2)
	# Get the screen size.
	screen_size = get_viewport_rect().size
	# Get necessary nodes for pathfinding.
	yield(get_tree(), "idle_frame")
	var tree = get_tree()
	if tree.has_group("LevelNavigation"):
		levelNavigation = tree.get_nodes_in_group("LevelNavigation")[0]
	if tree.has_group("Player"):
		player = tree.get_nodes_in_group("Player")[0]

func _physics_process(delta):
	"""
		This function is called every frame.
		It is called before the update function.
		delta is the time in seconds since the last frame.
	"""
	# Call function which decides the actions of the entity depending on the state.
	choose_action()
	# Move enemy.
	velocity = move_and_slide(move_in_direction(velocity))
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	# Make sure the animation is correct.
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
			# Stop enemy firing.
			fire = false
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
			# Cehck if the enemy may fire.
			_fire_check()
		states.CHASE:
			# Checks if there really is a player and navigation in the level.
			if player and levelNavigation:
				generate_path()
				navigate()
		states.KNOCKBACK:
			# Check if the knockback timer has been started.
			if $TimerKnockback.time_left <= 0:
				velocity = Vector2.ZERO
				timer_knockback.start()

			_knockback_Enemy()

func _knockback_Enemy():
	"""
		This function moves the enemy in the opposite direction of the player.
	"""
	var player_direction = (Player.get_position() - self.position).normalized()
	velocity = position.direction_to(Player.position) * -200

func _on_TimerKnockback_timeout():
	"""
		Changes the enemy back to the chase or fire state depending on the player position
		when the knockback timer runs out.
	"""
	if fire == true:
		state = states.FIRE
	else:
		state = states.CHASE

func _on_Range_body_entered(body):
	"""
		Changes the enemy to chase mode when the player enters the detection radius.
	"""
	state = states.CHASE

func _on_FiringRange_body_entered(body):
	"""
		Changes the enemy to fire mode when the player enters the fire radius.
	"""
	state = states.FIRE
	fire = true

func _on_FiringRange_body_exited(body):
	"""
		Changes the enemy to chase mode if the enemy isn't being knockbacked
		when the player exits the fire radius.
	"""
	if $TimerKnockback.time_left <= 0:
		state = states.CHASE
	fire = false


func _on_Timer_timeout():
	"""
		Stops fire timer and says the enemy can fire again.
	"""
	timer.stop()
	fire_counter = 0

func _fire_check():
	"""
		Checks if the enemy can fire.
	"""
	if fire_counter == 0:
		timer.start()
		fire()
		fire_counter = 1


func fire():
	"""
		Create instance of bullet and shoot in the direction of the player.
	"""
	var bullet = BULLET.instance()
	bullet.init(position, position.direction_to(Player.position) * 200, 2)
	get_parent().add_child(bullet)



func navigate():
	"""
		This function is called every frame.
		It is called after the update function.
	"""
	# Check if there is an available path and if so move to it.
	if path.size() > 0:
		velocity = global_position.direction_to(path[1]) * (_get_temp_speed() + _get_perm_speed())

	# If the destination is reached, remove this point from the array.
	if global_position == path[0]:
		path.pop_front()

func generate_path():
	"""
		This function is called every frame.
		It is called after the update function.
	"""
	if levelNavigation != null and player != null:
		# Generate path to the player with the navigationable tiles.
		path = levelNavigation.get_simple_path(global_position, player.global_position, false)
