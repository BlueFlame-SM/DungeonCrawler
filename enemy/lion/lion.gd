extends "res://character/character.gd"

enum states {PATROL, CHASE, ATTACK, KNOCKBACK, DEAD}

var state = states.PATROL
var time = 1
var screen_size
var velocity = Vector2()
var knockback = Vector2.ZERO

var path: Array = []
var levelNavigation: Navigation2D = null
#onready var player = get_node("../Player")
var player = Player

var current_direction = "forward"
var animation_cooldown = false

signal enemy_hit

var attack_counter = 0
onready var timer = $Timer
onready var timer_hurt = $Timer_anim_hurt
onready var timer_attack = $Timer_anim_attack
onready var timer_knockback = $TimerKnockback

# Called when the node enters the scene tree for the first time.
func _ready():
	# Set stats of the Lion.
	self._set_perm_speed(4)
	self._set_temp_speed(2)
	self._set_max_health(20)
	self._set_health(20)
	self._set_perm_damage(4)

	screen_size = get_viewport_rect().size
	"""Kan pas met nieuwe tileset, laten staan!!!"""
	yield(get_tree(), "idle_frame")
	var tree = get_tree()
	if tree.has_group("LevelNavigation"):
		levelNavigation = tree.get_nodes_in_group("LevelNavigation")[0]
	if tree.has_group("Player"):
		player = tree.get_nodes_in_group("Player")[0]
	$AnimatedSprite.animation = "default"

func _physics_process(delta):
	choose_action()
	velocity = move_and_slide(move_in_direction(velocity))
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)

	# If there is no attack animation playing, and the Lion is not knocked back or death,
	# set the sprite to the direction the Lion is currently going.
	if !animation_cooldown and state != states.KNOCKBACK and state != states.DEAD:
		if velocity == Vector2.ZERO:
			if (abs(Player.position.x - position.x) - abs(Player.position.y - position.y)) < 5:
				if Player.position.x - position.x > 0:
					$AnimatedSprite.animation = "idle"
					$AnimatedSprite.flip_h = true
					current_direction = "right"
				else:
					$AnimatedSprite.animation = "idle"
					$AnimatedSprite.flip_h = false
					current_direction = "left"
			else:
				if Player.position.y - position.y < 0:
					$AnimatedSprite.animation = "idle_back"
					$AnimatedSprite.flip_h = false
					current_direction = "back"
				else:
					$AnimatedSprite.animation = "idle_forward"
					$AnimatedSprite.flip_h = false
					current_direction = "forward"

		elif abs(velocity.x) - abs(velocity.y) > 5:
			if velocity.x > 0:
				$AnimatedSprite.animation = "default"
				$AnimatedSprite.flip_h = true
				current_direction = "right"
			elif velocity.x < 0:
				$AnimatedSprite.animation = "default"
				$AnimatedSprite.flip_h = false
				current_direction = "left"
		else:
			if velocity.y > 0:
				$AnimatedSprite.animation = "default_forward"
				$AnimatedSprite.flip_h = false
				current_direction = "forward"
			elif velocity.y < 0:
				$AnimatedSprite.animation = "default_back"
				$AnimatedSprite.flip_h = false
				current_direction = "back"

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
			$AnimatedSprite.animation = "on_hit"
			$Claws.animation = "default"
			velocity = Vector2.ZERO
			if time > 0:
				self.modulate.a = 0 if Engine.get_frames_drawn() % 5 == 0 else 1.0
			else:
				GlobalVars.challenge_down("lion")
				set_physics_process(false)
				queue_free()
		states.PATROL:
			velocity = Vector2.ZERO
		states.ATTACK:
			velocity = Vector2.ZERO
			if attack_counter == 0:
				_damage_player()
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
	state = states.CHASE

# If the player comes in the detection range, the enemy starts chasing the player.
func _on_Range_body_entered(body):
	state = states.CHASE

func _on_Player_hit(amount):
	do_damage(amount)

"""
Functies voor pathfinding zodat het niet achter bosjes blijft zitten, kan pas met nieuwe tileset.
"""
func navigate():	# Define the next position to go to
	if path.size() > 0:
		velocity = global_position.direction_to(path[1]) * (_get_temp_speed() + _get_temp_speed())

	# If the destination is reached, remove this path from the array
	if global_position == path[0]:
		path.pop_front()


# Generates a path to the player.
func generate_path():
	if levelNavigation != null and player != null:
		path = levelNavigation.get_simple_path(global_position, player.global_position, false)


# When the player enters Area2D named Hitbox, the enemy will change to ATTACK mode.
func _on_Hitbox_body_entered(body):
	state = states.ATTACK
#	print("attack")


# When the player exits Area2D named Hitbox, the enemy will change to CHASE mode.
func _on_Hitbox_body_exited(body):
	if $TimerKnockback.time_left <= 0:
		state = states.CHASE

"""
Gives damage to the player equal to the damage stat of the enemy
and starts a 1 second timer as cooldown for attack.
"""
func _damage_player():
	Player.do_damage(_get_temp_damage() + _get_perm_damage())
	animation_cooldown = true
	if current_direction == "left":
		$AnimatedSprite.animation = "attack"
	elif current_direction == "right":
		$AnimatedSprite.animation = "attack"
	elif current_direction == "forward":
		$AnimatedSprite.animation = "attack_forward"
	elif current_direction == "back":
		$Claws.animation = "attack"
		$AnimatedSprite.animation = "attack_back"

	timer_attack.start()
	timer.start()
	attack_counter = 1

func _on_Timer_timeout():
	timer.stop()
	attack_counter = 0


func _on_Enemy_healthChanged(newValue, dif):
	""" Once a enemy is hit, start playing the hurt animation and
		start the timer for the hurt animation.
	"""
	if timer_hurt != null:
		if current_direction == "left" or current_direction == "right":
			animation_cooldown = true
			$AnimatedSprite.animation = "on_hit"
			timer_hurt.start()


func _on_Timer_anim_attack_timeout():
	""" On the attack timeout, return to the default animation. """
	timer_attack.stop()
	if current_direction == "left" or current_direction == "right":
		$AnimatedSprite.animation = "default"
	else:
		$AnimatedSprite.animation = str("default_" + current_direction)
		$Claws.animation = "default"
	animation_cooldown = false


func _on_Timer_anim_hurt_timeout():
	""" On the hurt timeout, return to the default animation. """
	timer_hurt.stop()
	$AnimatedSprite.animation = "default"
	animation_cooldown = false
