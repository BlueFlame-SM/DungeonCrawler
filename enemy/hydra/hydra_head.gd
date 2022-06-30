extends "res://enemy_range/enemy_range.gd"

onready var timer_hurt = $Timer_anim_hurt
onready var timer_attack = $Timer_anim_attack

# Called when the node enters the scene tree for the first time.
func _ready():
	# Set states and default animation.
	_set_perm_speed(4)
	$AnimatedSprite.animation = "default"

	screen_size = get_viewport_rect().size

	# Set up navigation.
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
- Knockback: the sprite is knocked back for the timer duration.
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
			if player and levelNavigation:
				generate_path()
				navigate()
		states.KNOCKBACK:
			if $TimerKnockback.time_left <= 0:
				velocity = Vector2.ZERO
				timer_knockback.start()

			_knockback_Enemy()

func _on_FiringRange_body_entered(body):
	""" Start firing when a body enters the firing range. """
	state = states.FIRE
	fire = true

func _on_FiringRange_body_exited(body):
	""" Disable firing when a body leaves the firing range. Start chasing if
		if the knockback is finished.
	"""
	if $TimerKnockback.time_left <= 0:
		state = states.CHASE

	fire = false

func _on_Timer_timeout():
	""" On timeout, set counter to 0 to allow a new shot to be fired. """
	timer.stop()
	fire_counter = 0

func _fire_check():
	""" Fire a shot if the counter allows it. """
	if fire_counter == 0:
		timer.start()
		fire()
		fire_counter = 1

func fire():
	""" Fires to towards the player. """
	$AnimatedSprite.animation = "attack"
	timer_attack.start()
	var bullet = BULLET.instance()
	bullet.init(position, position.direction_to(Player.position) * 200, 2)
	get_parent().add_child(bullet)


func _on_EnemyRange_healthChanged(newValue, dif):
	""" Play the hurt animation when the enemy is damaged for the timer
		hurt duration.
	"""
	if timer_hurt != null:
		$AnimatedSprite.animation = "hurt"
		timer_hurt.start()


func _on_Timer_anim_hurt_timeout():
	""" Return to the default animation on timeout. """
	timer_hurt.stop()
	$AnimatedSprite.animation = "default"


func _on_Timer_anim_attack_timeout():
	""" Return to default animation on timeout. """
	timer_attack.stop()
	$AnimatedSprite.animation = "default"
