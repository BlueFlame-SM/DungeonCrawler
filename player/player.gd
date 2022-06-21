extends "res://character/character.gd"

# Variables for player animation
var playAttack = false
var lastDirection = Vector2.LEFT

# onready var healthbar = $HealthBar
onready var weapon = $Weapon

# When player hits enemy
signal hit(amount)

# Attack cooldown variables
var attack_cooldown_time = 100
var next_attack_time = 0

func _ready():
	speed = 3

func playAnimations(velocity: Vector2, delta: float) -> void:
	# Only move if attack animation is not playing
	if !self.can_move:
		print("cant move")
	if !playAttack:
		if velocity.length() > 0:
			velocity = velocity.normalized() * speed
			$AnimatedSprite.play()
		else:
			$AnimatedSprite.stop()

		position += velocity * delta

		if velocity.x > 0:
			$AnimatedSprite.animation = "walk_left"
			$AnimatedSprite.flip_h = true
			$AnimatedSprite.flip_v = false
		elif velocity.x < 0:
			$AnimatedSprite.animation = "walk_left"
			$AnimatedSprite.flip_h = false
			$AnimatedSprite.flip_v = false
		elif velocity.y > 0:
			$AnimatedSprite.animation = "walk_down"
			$AnimatedSprite.flip_h = false
			$AnimatedSprite.flip_v = false
		elif velocity.y < 0:
			$AnimatedSprite.animation = "walk_up"
			$AnimatedSprite.flip_h = false
			$AnimatedSprite.flip_v = false
		elif velocity.x == 0 and velocity.y == 0:
			if lastDirection == Vector2.DOWN:
				$AnimatedSprite.animation = "idle_down"
			elif lastDirection == Vector2.UP:
				$AnimatedSprite.play("idle_up")
			elif lastDirection == Vector2.LEFT:
				$AnimatedSprite.play("idle_left")
				$AnimatedSprite.flip_h = false
			else:
				$AnimatedSprite.animation = "idle_left"
				$AnimatedSprite.flip_h = true
			$AnimatedSprite.flip_v = false
	# Play attack animation based on direction
	else:
		if lastDirection == Vector2.DOWN:
			$AnimatedSprite.play("front_slash")
		elif lastDirection == Vector2.UP:
			$AnimatedSprite.play("back_slash")
		else:
			$AnimatedSprite.play("left_slash")


func _physics_process(delta: float) -> void:
	var direction = Vector2.ZERO
	if !self.can_move:
		direction.x = 0
		direction.y = 0

	else:
		if Input.is_action_pressed("left"):
			direction.x -= 1
			lastDirection = Vector2.LEFT
		if Input.is_action_pressed("right"):
			direction.x += 1
			lastDirection = Vector2.RIGHT
		if Input.is_action_pressed("up"):
			direction.y -= 1
			lastDirection = Vector2.UP
		if Input.is_action_pressed("down"):
			direction.y += 1
			lastDirection = Vector2.DOWN
		if Input.is_action_just_pressed("attack"):
			var now = OS.get_ticks_msec()
			# Only attack if cooldown is up
			if now >= next_attack_time:
				# Play attack animation
				playAttack = true
				# Attack
				weapon.attack(lastDirection)
				# Add cooldown time to current time
				next_attack_time = now + attack_cooldown_time

	var velocity = move_and_slide(move_in_direction(direction))
	position += velocity * delta
	playAnimations(velocity, delta)


func _on_AnimatedSprite_animation_finished():
	# If attack animation is done, player can move again
	playAttack = false
	$AnimatedSprite.play("idle_left")
	weapon.disableHurtBox()


func _on_HazardNotifier_body_entered(body):
	do_damage(2)
	print("HP: {}/{}".format([health, max_health], "{}"))

#Dit werkyt niet, doet damage aan zichzelf.
func _on_Weapon_body_entered(body):
	print(body.name)
	print("weapon hit enemy (not necessarilly)")
	body.do_damage(2)
	emit_signal("hit", weapon.damage)

func die():
	self.can_move = false
	LevelSwitcher.goto_scene("res://levels/Level0.tscn", true)
	pass



# CONNECT HIT SIGNAL TO ENEMY
# ADD THIS TO ENEMY SCRIPT
#func _on_Player_hit(amount):
#	damage(amount)
#	print(health)

# Checks for input.
func _input(event):
	if event.is_action_pressed("interact"):
		var items = $Pickup.get_overlapping_bodies()
		if items.size() > 0:
			var item = items[0]
			item.pick_up_item(self)
