"""
	Script for the player.
	This script is responsible for the player's movement and interaction with the environment.
	It also handles the player's health and death.


	Global variables:
		player: The player object.
"""

extends "res://character/character.gd"


var playAttack = false
var lastDirection = Vector2.LEFT

onready var weapon = $Weapon
onready var timer = $Timer
signal hit(amount)

# Attack cooldown variables
var ranged_weapon = false
var next_attack_time = 0
var extra_speed = 0
var extra_damage = 0
var extra_atk_speed = 0

func _ready():
	self._set_perm_speed(0)
	self._set_max_health(40)
	self._set_health(40)


func playAnimations(velocity: Vector2, delta: float) -> void:
	"""
		This function is responsible for playing the player's animations.
		It is called every frame.

		Parameters:
			velocity: The player's current velocity.
			delta: The time since the last frame.

		Returns:
			void
	"""
	if !playAttack:
		if velocity.length() > 0:
			velocity = velocity.normalized() * (self._get_temp_speed() + self._get_perm_speed())

			$AnimatedSprite.play()
		else:
			$AnimatedSprite.stop()

		position += velocity * delta

		if velocity.x > 0:
			$AnimatedSprite.animation = "walk_left"
			$AnimatedSprite.flip_h = true
		elif velocity.x < 0:
			$AnimatedSprite.animation = "walk_left"
			$AnimatedSprite.flip_h = false
		elif velocity.y > 0:
			$AnimatedSprite.animation = "walk_down"
			$AnimatedSprite.flip_h = false
		elif velocity.y < 0:
			$AnimatedSprite.animation = "walk_up"
			$AnimatedSprite.flip_h = false
		elif velocity.x == 0 and velocity.y == 0:
			if lastDirection == Vector2.DOWN:
				$AnimatedSprite.animation = "idle_down"
			elif lastDirection == Vector2.UP:
				$AnimatedSprite.animation = "idle_up"
			elif lastDirection == Vector2.LEFT:
				$AnimatedSprite.animation = "idle_left"
				$AnimatedSprite.flip_h = false
			else:
				$AnimatedSprite.animation = "idle_left"
				$AnimatedSprite.flip_h = true
	# Play attack animation based on direction
	else:
		if lastDirection == Vector2.DOWN:
			$AnimatedSprite.play("front_slash")
		elif lastDirection == Vector2.UP:
			$AnimatedSprite.play("back_slash")
		else:
			$AnimatedSprite.play("left_slash")

	# If character speed increases then increase FPS of animation.
	if self._get_perm_speed() > 5:
		$AnimatedSprite.set_speed_scale(2)
		if self._get_perm_speed() < 5:
			$AnimatedSprite.set_speed_scale(0)

func _physics_process(delta: float) -> void:
	"""
		This function is responsible for the player's physics.
		It is called every frame.

		Parameters:
			delta: The time since the last frame.

		Returns:
			void
	"""
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
				$SlashSound.play()
				# Play attack animation
				playAttack = true
				# Attack
				weapon.attack(lastDirection)
				# Add cooldown time to current time
				next_attack_time = now + self._get_cooldown_time()

		# Inventory can't be opened during start screen.
		if GlobalVars.level_counter != 0:
			if Input.is_action_just_pressed("inventory"):
				$CanvasLayer/Inventory.visible = !$CanvasLayer/Inventory.visible
			$CanvasLayer/Hotbar.visible = true

	var velocity = move_and_slide(move_in_direction(direction))
	position += velocity * delta
	playAnimations(velocity, delta)


func _on_AnimatedSprite_animation_finished():
	"""
		Stops animation attack.
	"""
	playAttack = false
	weapon.disableHurtBox()


func _on_Weapon_body_entered(body):
	"""
		This function is called when the player's weapon hits an enemy.

		Parameters:
			body: The body that was hit.
	"""
	if body.name != "Player":
		body.do_damage(self.perm_damage + self.temp_damage)
		emit_signal("hit", self.perm_damage + self.temp_damage)
		body.state = body.states.KNOCKBACK

func hurt():
	$HurtSound.play()


func die():
	"""
		When the player dies, the player stops being able to move. The next level is
		the start level. We then call the levelswitcher to go to the start level.
	"""
	GlobalVars.level_type = "game_over"
	do_damage(health)
	self.can_move = false
	LevelSwitcher.goto_scene("res://interface/death_screen.tscn", true)


func _input(event):
	if event.is_action_pressed("pick_up"):
		var items = $Pickup.get_overlapping_bodies()
		if items.size() > 0:
			var item = items[0]
			$PickUpSound.play()
			item.pick_up_item(self)


func _on_Player_healthChanged(newValue, dif):
	"""
		Function called to change health player.
	"""
	if dif < 0:
		if Player.health <= 0:
			Player.die()
			$CanvasLayer/Inventory.visible = false
	pass



func _on_Inventory_use_health_potion():
	"""
		This function is called when the player uses a health potion.
		It restores the player's health.
	"""
	Player.heal(JsonData.item_data[$CanvasLayer/Inventory.use_item.item_name]["HP_healed"])
	print("HP: {}/{}".format([health, max_health], "{}"))


func _on_Inventory_use_melee_weapon():
	"""
		This function is called when the player uses a melee weapon.
		It sets the weapon to the melee weapon.
	"""
	self.temp_damage = JsonData.item_data[$CanvasLayer/Inventory.use_item.item_name]["Damage"]
	self.temp_attack_speed = JsonData.item_data[$CanvasLayer/Inventory.use_item.item_name]["Attack_speed"]
	self.range_weapon = JsonData.item_data[$CanvasLayer/Inventory.use_item.item_name]["Range"]
	$Weapon/HurtBox.scale = Vector2(_get_range_weapon(), _get_range_weapon())
	self.temp_speed = JsonData.item_data[$CanvasLayer/Inventory.use_item.item_name]["Speed_change"]


func _on_Inventory_use_permanent_stat_increase():
	"""
		This function is called when the player uses a permanent stat increase.
		It increases the permanent stat increase.
	"""
	self._set_max_health(self._get_max_health() + JsonData.item_data[$CanvasLayer/Inventory.use_item.item_name]["Max_HP"])
	self._set_perm_speed(JsonData.item_data[$CanvasLayer/Inventory.use_item.item_name]["Speed"] + self._get_perm_speed())
	self._set_perm_damage(JsonData.item_data[$CanvasLayer/Inventory.use_item.item_name]["Damage"] + self._get_perm_damage())
	self._set_perm_attack_speed(JsonData.item_data[$CanvasLayer/Inventory.use_item.item_name]["Attack_speed"] + self._get_perm_attack_speed())

func _on_Inventory_use_potion():
	"""
		This function is called when the player uses a potion.
		It restores the player's health.
	"""
	extra_speed = JsonData.item_data[$CanvasLayer/Inventory.use_item.item_name]["Speed"]
	extra_damage = JsonData.item_data[$CanvasLayer/Inventory.use_item.item_name]["Damage"]
	extra_atk_speed = JsonData.item_data[$CanvasLayer/Inventory.use_item.item_name]["Attack_speed"]
	self.temp_speed = JsonData.item_data[$CanvasLayer/Inventory.use_item.item_name]["Speed"] + self._get_temp_speed()
	self.temp_damage = JsonData.item_data[$CanvasLayer/Inventory.use_item.item_name]["Damage"] + self._get_temp_damage()
	self.temp_attack_speed = JsonData.item_data[$CanvasLayer/Inventory.use_item.item_name]["Attack_speed"] + self._get_temp_attack_speed()
	timer.start()


func _on_Timer_timeout():
	"""
		This function is called when the player's potion timer runs out.
		It sets the player's health back to normal.
	"""
	timer.stop()
	Player._set_temp_speed(Player._get_temp_speed() - extra_speed)
	Player._set_temp_damage(Player._get_temp_damage() - extra_damage)
	Player._set_temp_attack_speed(Player._get_temp_attack_speed() - extra_atk_speed)


func _on_Inventory_use_lion_hide():
	"""
		This function is called when the player uses a lion hide.
		It increases the player's speed.
	"""
	Player._set_defence(Player._get_defence() + JsonData.item_data[$CanvasLayer/Inventory.use_item.item_name]["Defence"])
