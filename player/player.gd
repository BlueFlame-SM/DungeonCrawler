extends "res://character/character.gd"

# Variables for player animation
var playAttack = false
var lastDirection = Vector2.LEFT

# onready var healthbar = $HealthBar
onready var weapon = $Weapon
onready var timer = $Timer
# When player hits enemy
signal hit(amount)

# Attack cooldown variables
var ranged_weapon = false
var next_attack_time = 0
var extra_speed = 0
var extra_damage = 0

func _ready():
	self._set_perm_speed(0)

func playAnimations(velocity: Vector2, delta: float) -> void:
	# Only move if attack animation is not playing
	if !playAttack:
		if velocity.length() > 0:
			print(_get_temp_speed() + _get_perm_speed())
			velocity = velocity.normalized() * (_get_temp_speed() + _get_perm_speed())
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
	# If attack animation is done, player can move again
	playAttack = false
	weapon.disableHurtBox()


func _on_HazardNotifier_body_entered(body):
	do_damage(2)
	print("HP: {}/{}".format([health, max_health], "{}"))

func _on_Weapon_body_entered(body):
	if body.name != "Player":
		body.do_damage(2)
		emit_signal("hit", weapon.damage)
		$HurtSound.play()
		body.state = body.states.KNOCKBACK


"""
When the player dies, the player stops being able to move. The next level is
the start level. We then call the levelswitcher to go to the start level.
"""
func die():
	self.can_move = false
	GlobalVars.level_type = "start"
	LevelSwitcher.goto_scene("res://levels/LevelStart.tscn", true)

# Checks for input.
func _input(event):
	if event.is_action_pressed("pick_up"):
		var items = $Pickup.get_overlapping_bodies()
		if items.size() > 0:
			var item = items[0]
			$PickUpSound.play()
			item.pick_up_item(self)


func _on_Player_healthChanged(newValue, dif):
	if dif < 0:
		if GlobalVars.level_type != "start":
				$AnimatedSprite.play("hit_effect")
				$HurtSound.play()
		if Player.health <= 0:
			Player.die()
	pass

func _on_Inventory_use_health_potion():
	Player.heal(JsonData.item_data[$CanvasLayer/Inventory.use_item.item_name]["HP_healed"])


func _on_Inventory_use_melee_weapon():
	self._set_temp_damage(JsonData.item_data[$CanvasLayer/Inventory.use_item.item_name]["Damage"])
	self._set_attack_speed(JsonData.item_data[$CanvasLayer/Inventory.use_item.item_name]["Attack_speed"])
	self._set_range_weapon(JsonData.item_data[$CanvasLayer/Inventory.use_item.item_name]["Range"])
	$Weapon/HurtBox.scale = Vector2(_get_range_weapon(), _get_range_weapon())
	self._set_temp_speed(JsonData.item_data[$CanvasLayer/Inventory.use_item.item_name]["Speed_change"])


func _on_Inventory_use_permanent_stat_increase():
	self._set_max_health(self._get_max_health() + JsonData.item_data[$CanvasLayer/Inventory.use_item.item_name]["Max_HP"])
	print(JsonData.item_data[$CanvasLayer/Inventory.use_item.item_name]["Speed"])
	self._set_perm_speed(JsonData.item_data[$CanvasLayer/Inventory.use_item.item_name]["Speed"] + _get_perm_speed())
	self._set_perm_damage(JsonData.item_data[$CanvasLayer/Inventory.use_item.item_name]["Damage"] + _get_perm_damage())


func _on_Inventory_use_potion():
	extra_speed = JsonData.item_data[$CanvasLayer/Inventory.use_item.item_name]["Speed"]
	extra_damage = JsonData.item_data[$CanvasLayer/Inventory.use_item.item_name]["Damage"]
	self._set_temp_speed(JsonData.item_data[$CanvasLayer/Inventory.use_item.item_name]["Speed"] + Player._get_temp_speed())
	self._set_temp_damage(JsonData.item_data[$CanvasLayer/Inventory.use_item.item_name]["Damage"] + Player._get_temp_damage())
	timer.start()


func _on_Timer_timeout():
	timer.stop()
	print(_get_temp_speed())
	Player._set_temp_speed(Player._get_temp_speed() - extra_speed)
	Player._set_temp_damage(Player._get_temp_damage() - extra_damage)
	print(_get_temp_speed())
