extends "res://enemy_range/enemy_range.gd"

onready var timer_hurt = $Timer_anim_hurt
onready var timer_attack = $Timer_anim_attack

# Called when the node enters the scene tree for the first time.
func _ready():
	_set_perm_speed(4)
	screen_size = get_viewport_rect().size
	$AnimatedSprite.animation = "default"
	"""Kan pas met nieuwe tileset, laten staan!!!"""
	yield(get_tree(), "idle_frame")
	var tree = get_tree()
	if tree.has_group("LevelNavigation"):
		levelNavigation = tree.get_nodes_in_group("LevelNavigation")[0]
	if tree.has_group("Player"):
		player = tree.get_nodes_in_group("Player")[0]

"""
Chooses the right state at the right moment:
- Dead: the sprite flickers and then gets removed from the queue.
- Patrol: the sprite waits for the player to enter the range.
- Fire: the sprite fires every n frames a bullet at the player.
"""
func choose_action():
	match state:
		states.DEAD:
			$AnimatedSprite.animation = "hurt"
			velocity = Vector2.ZERO
			fire = false
			if time > 0:
				self.modulate.a = 0 if Engine.get_frames_drawn() % 5 == 0 else 1.0
			else:
				GlobalVars.challenge_down("hydra")
				set_physics_process(false)
				queue_free()
		states.PATROL:
			velocity = Vector2.ZERO
		states.FIRE:
			velocity = Vector2.ZERO
			_fire_check()
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

func _on_FiringRange_body_entered(body):
	state = states.FIRE
	fire = true

func _on_FiringRange_body_exited(body):
	if $TimerKnockback.time_left <= 0:
		state = states.CHASE

	fire = false

func _on_Timer_timeout():
	timer.stop()
	fire_counter = 0

func _fire_check():
	if fire_counter == 0:
		timer.start()
		fire()
		fire_counter = 1

""" Fires to towards the player. """
func fire():
	$AnimatedSprite.animation = "attack"
	timer_attack.start()
	var bullet = BULLET.instance()
	bullet.init(position, position.direction_to(Player.position) * 200, 2)
	get_parent().add_child(bullet)

# Generates a neck of enemies to the player.
func _on_EnemyRange_healthChanged(newValue, dif):
	if timer_hurt != null:
		$AnimatedSprite.animation = "hurt"
		timer_hurt.start()

# Generates a neck of enemies to the player.
func _on_Timer_anim_hurt_timeout():
	timer_hurt.stop()
	$AnimatedSprite.animation = "default"

# Generates a neck of enemies to the player.
func _on_Timer_anim_attack_timeout():
	timer_attack.stop()
	$AnimatedSprite.animation = "default"

