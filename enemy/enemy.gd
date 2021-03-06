"""
	Script for the enemy.
	This script is used to control the enemy.
	It is used to move the enemy and to detect if the enemy is hit by the player.

	This video was used for the pathfinding.
	https://www.youtube.com/watch?v=gFlGMLmg8yg
"""

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

signal enemy_hit

var attack_counter = 0
onready var timer = $Timer
onready var timer_hurt = $Timer_anim_hurt
onready var timer_attack = $Timer_anim_attack
onready var timer_knockback = $TimerKnockback

onready var hitbox = $Hitbox


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
	# Set the initial animation.
	$AnimatedSprite.animation = "default"

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
	if health == 0:
		state = states.DEAD
	match state:
		states.DEAD:
			time -= delta


func choose_action():
	"""
	Chooses the right state at the right moment:
	- Dead: the sprite flickers and then gets removed from the queue.
	- Patrol: the sprite waits for the player to enter the range.
	- Attack: Sprite doesn't move when attacking, gets thrown back.
	- Knockback: Enemy gets knocked back, then goes back to chasing.
	"""
	match state:
		states.DEAD:
			$AnimatedSprite.animation = "on_hit"
			velocity = Vector2.ZERO
			# Disables the hitbox so it doesn't damage the player.
			hitbox.get_node("CollisionShape2D").disabled = true
			if time > 0:
				self.modulate.a = 0 if Engine.get_frames_drawn() % 5 == 0 else 1.0
			else:
				GlobalVars.challenge_down("enemy", self.position)
				set_physics_process(false)
				queue_free()
		states.PATROL:
			velocity = Vector2.ZERO
		states.ATTACK:
			velocity = Vector2.ZERO
			# If the enemy can attack call damage_player().
			if attack_counter == 0:
				_damage_player()
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
		Changes the enemy back to the chase state when the knockback timer runs out.
	"""
	state = states.CHASE


func _on_Range_body_entered(body):
	"""
		Changes the enemy to chase mode when the player enters the detection radius.
	"""
	state = states.CHASE


func navigate():
	"""
		This function is called every frame.
		It is called after the update function.
	"""
	# Check if there is an available path and if so move to it.
	if path.size() > 0:
		velocity = global_position.direction_to(path[1]) * (self._get_perm_speed() + self._get_temp_speed())

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
		# Make sure the animation is in the right orientation.
		if path[-1].x > path[-2].x:
			$AnimatedSprite.flip_h = true
		else:
			$AnimatedSprite.flip_h = false


func _on_Hitbox_body_entered(body):
	"""
		Changes the enemy to attack mode when the player enters the hitbox radius.
	"""
	state = states.ATTACK


func _on_Hitbox_body_exited(body):
	"""
		Changes the enemy back to chase mode when the player leaves the hitbox radius.
	"""
	# Check if the enemy isn't still being knockbacked.
	if $TimerKnockback.time_left <= 0:
		state = states.CHASE


func _damage_player():
	"""
		Gives damage to the player equal to the damage stat of the enemy
		and starts a 1 second timer as cooldown for attack.
	"""
	# Damage player according to the permanent and temporary damage.
	Player.do_damage(_get_temp_damage() + _get_perm_damage())
	$AnimatedSprite.animation = "attack"
	Player.hurt()
	# Start attack and attack animation timer.
	timer_attack.start()
	timer.start()
	attack_counter = 1

func _on_Timer_timeout():
	timer.stop()
	# Make it so the enemy can attack the player again.
	attack_counter = 0


func _on_Enemy_healthChanged(newValue, dif):
	"""
		Start animation hurt and set timer.
	"""
	$AnimatedSprite.animation = "on_hit"
	timer_hurt.start()


func _on_Timer_anim_attack_timeout():
	"""
		Stop animation attack and set it to default again.
	"""
	timer_attack.stop()
	$AnimatedSprite.animation = "default"


func _on_Timer_anim_hurt_timeout():
	"""
		Stop animation hurt and set it to default again.
	"""
	timer_hurt.stop()
	$AnimatedSprite.animation = "default"
