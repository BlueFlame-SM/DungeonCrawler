extends "res://character/character.gd"

enum states {IDLE, ATTACK, DEAD, FIRE, KNOCKBACK}

# Load fireball scene.
const BULLET := preload("res://bullet/bullet_cerberus.tscn")

var state = states.IDLE
var time = 1
var screen_size

# Counters to space the attacks.
var attack_counter = 0
var fire_counter = 0
var music_counter = true

# Boolean if Cerberus can fire.
var fire = false

# Boolean if Player is within bitting range.
var in_bite_range = false

signal enemy_hit

onready var timer_bite = $TimerBite
onready var timer_fire = $TimerFire
onready var timer_attack = $Timer_anim_attack
onready var hitbox = $Hitbox


# Called when the node enters the scene tree for the first time.
func _ready():
	""" Set starting stats and default animation. """
	self._set_perm_speed(0)
	self._set_max_health(100)
	self._set_health(100)
	self._set_perm_damage(10)

	screen_size = get_viewport_rect().size
	$AnimatedSprite.animation = "default"


func _physics_process(delta):
	choose_action()

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
			# Disables the hitbox so it doesn't damage the player.
			$Hitbox/CollisionPolygon2D.disabled = true
			if $WinSound.playing == false:
				$WinSound.play()
			if time > 0:
				self.modulate.a = 0 if Engine.get_frames_drawn() % 5 == 0 else 1.0
			else:
				GlobalVars.challenge_down("cerberus", self.position)
				set_physics_process(false)
				queue_free()
		states.ATTACK:
			if attack_counter == 0:
				_damage_player()
				$SlashSound.play()
		states.KNOCKBACK:
			# Do nothing, as Cerberus can't be knocked back, but its a state
			# that is inherited from character.
			pass
		states.IDLE:
			pass
		states.FIRE:
			if fire_counter == 0:
				fire()

func _on_Hitbox_body_entered(body):
	""" When the player enters the Hitbox, set it is within bitting range,
		disable the firing and change state to attack.
	"""
	in_bite_range = true
	fire = false
	state = states.ATTACK


func _on_Hitbox_body_exited(body):
	""" When the player exists the Hitbox, set it is out of the bitting range,
		enable firing and change the state to fire.
	"""
	in_bite_range = false
	fire = true
	state = states.FIRE


func _damage_player():
	""" Gives damage to the player equal to the damage stat of the enemy
	and starts a 1 second timer as cooldown for attack.
	"""

	timer_attack.start()
	timer_bite.start()
	attack_counter = 1

	# Give the player 0.5 to dodge the attack, and if it is stil in range
	# after that time, do damage. Always play the attack animation.
	yield(get_tree().create_timer(0.5), "timeout")
	if in_bite_range:
		Player.do_damage(_get_temp_damage() + _get_perm_damage())
		Player.get_node("CerberusBite").animation = "bitten"
		Player.hurt()

	$AnimatedSprite.animation = "attack"


func _on_Timer_anim_attack_timeout():
	""" Upon timeout, set all the attack animations back to the default. """
	timer_attack.stop()
	$AnimatedSprite.animation = "default"
	Player.get_node("CerberusBite").animation = "default"


func _on_FiringRange_body_entered(body):
	""" Fire fireballs if the player is in range and not within
		bitting range.
	"""
	# Upon first entering, wait 2.0 before starting firing.
	yield(get_tree().create_timer(2.0), "timeout")

	# If not within the bitting range, start firing fireballs.
	if !in_bite_range:
		state = states.FIRE
		fire()
		fire = true
		timer_fire.start(0)


func _on_FiringRange_body_exited(body):
	""" If the player is out of fire range, disable firing mode. """
	fire = false
	timer_fire.stop()


func fire():
	""" Create a bullet add it as a child. Set the fire counter. """
	var bullet = BULLET.instance()

	# Center start position on middle head.
	var start_pos = Vector2(position.x + 100, position.y)
	var velocity = start_pos.direction_to(Player.position) * 200
	bullet.init(start_pos, velocity, 5)
	get_parent().add_child(bullet)

	fire_counter = 1


func _on_TimerBite_timeout():
	""" Upon timeout, allow Cerberus to attack again. """
	timer_bite.stop()
	attack_counter = 0


func _on_TimerFire_timeout():
	""" Upon timeout, allow Cerberus to fire again. """
	fire_counter = 0

	if fire != false and !in_bite_range:
		fire()
