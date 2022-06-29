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
var potion_speed = 0
var potion_damage = 0
var potion_dexterity = 0

func _ready():
	self.max_health = 40
	self.health = 40


func playAnimations(velocity: Vector2, delta: float) -> void:
	# Only move if attack animation is not playing
	if !playAttack:
		if velocity.length() > 0:
			velocity = velocity.normalized() * self.get_speed()

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
	if self.get_speed() > 5:
		$AnimatedSprite.set_speed_scale(2)
	else:
		$AnimatedSprite.set_speed_scale(0)

func _physics_process(delta: float) -> void:
	var direction = Vector2.ZERO

	if self.can_move:
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
				next_attack_time = now + self.get_attack_delay()

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


func _on_Weapon_body_entered(body):
	if body.name != "Player":
		body.take_damage(get_damage())
		emit_signal("hit", get_damage())
		body.state = body.states.KNOCKBACK


func hurt():
	$HurtSound.play()


"""
When the player dies, the player stops being able to move. The next level is
the start level. We then call the levelswitcher to go to the start level.
"""
func die():
	GlobalVars.level_type = "game_over"
	self.health = 0
	self.can_move = false
	LevelSwitcher.goto_scene("res://interface/death_screen.tscn", true)

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
#				$HurtSound.play()
		print(self.health)
		if Player.health <= 0:
			Player.die()
			print("died")


func _on_Inventory_use_health_potion():
	self.heal(JsonData.item_data[$CanvasLayer/Inventory.use_item.item_name]["HP_healed"])
	print("HP: {}/{}".format([health, max_health], "{}"))


func _on_Inventory_use_melee_weapon():
	self.damage_bonus = JsonData.item_data[$CanvasLayer/Inventory.use_item.item_name]["Damage"] + potion_damage
	self.dexterity_bonus = JsonData.item_data[$CanvasLayer/Inventory.use_item.item_name]["Attack_speed"] + potion_dexterity
	self.reach_bonus = JsonData.item_data[$CanvasLayer/Inventory.use_item.item_name]["Range"]
	self.speed_bonus = JsonData.item_data[$CanvasLayer/Inventory.use_item.item_name]["Speed_change"] + potion_speed

	$Weapon/HurtBox.scale = Vector2(get_reach(), get_reach())


func _on_Inventory_use_permanent_stat_increase():
	self.max_health += JsonData.item_data[$CanvasLayer/Inventory.use_item.item_name]["Max_HP"]
	self.speed += JsonData.item_data[$CanvasLayer/Inventory.use_item.item_name]["Speed"]
	self.strength += JsonData.item_data[$CanvasLayer/Inventory.use_item.item_name]["Damage"]
	self.dexterity += JsonData.item_data[$CanvasLayer/Inventory.use_item.item_name]["Attack_speed"]


func _on_Inventory_use_potion():
	var speed_change = JsonData.item_data[$CanvasLayer/Inventory.use_item.item_name]["Speed"]
	var damage_change = JsonData.item_data[$CanvasLayer/Inventory.use_item.item_name]["Damage"]
	var dexterity_change = JsonData.item_data[$CanvasLayer/Inventory.use_item.item_name]["Attack_speed"]
	self.speed_bonus += speed_change
	self.damage_bonus += damage_change
	self.dexterity_bonus += dexterity_change
	potion_speed += speed_change
	potion_damage += damage_change
	potion_dexterity += dexterity_change
	timer.start()


func _on_Timer_timeout():
	self.speed_bonus -= potion_speed
	self.damage_bonus -= potion_damage
	self.dexterity_bonus -= potion_dexterity
	potion_speed = 0
	potion_damage = 0
	potion_dexterity = 0
