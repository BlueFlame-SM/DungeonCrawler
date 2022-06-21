extends "res://character/character.gd"

enum states {PATROL, CHARGE, DEAD}

var state = states.PATROL
var time = 1
var screen_size
var velocity = Vector2()
var knockback = Vector2.ZERO
var player_pos = Vector2.ZERO
var enemy_pos = Vector2.ZERO
var t = 0.0
var path: Array = []
var levelNavigation: Navigation2D = null

onready var timer = $Timer


# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size

func _physics_process(delta):
	choose_action()

"""
Chooses the right state at the right moment:
- Dead: the sprite flickers and then gets removed from the queue.
- Patrol: the sprite waits for the player to enter the range.
- Charge: the enemy teleports to the location of the player.
"""
func choose_action():
	match state:
		states.DEAD:
			velocity = Vector2.ZERO
			if time > 0:
				self.modulate.a = 0 if Engine.get_frames_drawn() % 5 == 0 else 1.0
			else:
				set_physics_process(false)
				queue_free()
		states.PATROL:
			velocity = Vector2.ZERO
		states.CHARGE:
			charge()


func _on_Range_body_entered(body):
	player_pos = get_player_pos()
	enemy_pos = get_enemy_pos()
	timer.start()


func charge():
	self.position = player_pos


func _on_Player_hit(amount):
	do_damage(amount)
	print("Enemy health", health)


func _on_Timer_timeout():
	player_pos = get_player_pos()
	enemy_pos = get_enemy_pos()
	state = states.CHARGE


func get_player_pos():
	return Player.get_position()

func get_enemy_pos():
	return self.position
