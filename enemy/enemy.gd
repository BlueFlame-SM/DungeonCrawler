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
	$AnimatedSprite.animation = "default"

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
			$AnimatedSprite.animation = "on_hit"
			velocity = Vector2.ZERO
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
			if attack_counter == 0:
				_damage_player()
		states.CHASE:
			""" Weer tileset"""
			if player and levelNavigation:
				generate_path()
				navigate()
		states.KNOCKBACK:
			var player_direction = (Player.get_position() - self.position).normalized()
			velocity = position.direction_to(Player.position) * -200

func _on_Range_body_entered(body):
	state = states.CHASE

func _on_Player_hit(amount):
	do_damage(amount)

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
		if path[-1].x > path[-2].x:
			$AnimatedSprite.flip_h = true
		else:
			$AnimatedSprite.flip_h = false

# When the player enters Area2D named Hitbox, the enemy will change to ATTACK mode.
func _on_Hitbox_body_entered(body):
	state = states.ATTACK

# When the player exits Area2D named Hitbox, the enemy will change to CHASE mode.
func _on_Hitbox_body_exited(body):
	state = states.CHASE

"""
Gives damage to the player equal to the damage stat of the enemy
and starts a 1 second timer as cooldown for attack.
"""
func _damage_player():
	Player.do_damage(self._get_temp_damage())
	$AnimatedSprite.animation = "attack"
	timer_attack.start()
	timer.start()
	attack_counter = 1

func _on_Timer_timeout():
	timer.stop()
	attack_counter = 0


func _on_Enemy_healthChanged(newValue, dif):
	$AnimatedSprite.animation = "on_hit"
	timer_hurt.start()


func _on_Timer_anim_attack_timeout():
	timer_attack.stop()
	$AnimatedSprite.animation = "default"


func _on_Timer_anim_hurt_timeout():
	timer_hurt.stop()
	$AnimatedSprite.animation = "default"
