extends "res://character/character.gd"

enum States {
	DISABLED,
	PATROL,
	WINDUP,
	CHARGE,
	CONFUSED,
	DIEING,
}

signal dieing
signal died(position)

export(float, 0) var detection_range = 250
export(float, 0) var windup_time = 2
export(float, 0) var charge_time = 0.25
export(float, 0) var confused_time = 2
export(float, 0) var dieing_time = 1

var charge_direction
var windup_timer
var charge_timer
var confused_timer
var dieing_timer

onready var state = States.DISABLED

func _physics_process(delta):
	match state:
		States.DISABLED:
			_on_state_disabled(delta)
		States.PATROL:
			_on_state_patrol(delta)
		States.WINDUP:
			_on_state_windup(delta)
		States.CHARGE:
			_on_state_charge(delta)
		States.CONFUSED:
			_on_state_confused(delta)
		States.DIEING:
			_on_state_dieing(delta)


func _on_state_disabled(delta):
	_set_state_patrol()


func _set_state_patrol():
	state = States.PATROL


func _on_state_patrol(delta):
	_try_charge()


func _set_state_windup():
	charge_direction = position.direction_to(Player.position)
	windup_timer = windup_time
	state = States.WINDUP


func _on_state_windup(delta):
	windup_timer -= delta
	if windup_timer <= 0:
		_set_state_charge()


func _set_state_charge():
	charge_timer = charge_time
	state = States.CHARGE


func _on_state_charge(delta):
	charge_timer -= delta
	if charge_timer <= 0:
		_set_state_patrol()
	else:
		var velocity = charge_direction * 1000
		var collision = move_and_collide(velocity * delta)
		if collision != null:
			if collision.collider == Player:
				Player.do_damage(3)
#				print(Player.health)
				_set_state_patrol()
			else:
				_set_state_confused()


func _set_state_confused():
	confused_timer = confused_time
	state = States.CONFUSED


func _on_state_confused(delta):
	confused_timer -= delta
	if confused_timer <= 0:
		_set_state_patrol()


func _set_state_dieing():
	emit_signal("dying")
	dieing_timer = dieing_time
	state = States.DIEING


func _on_state_dieing(delta):
	dieing_timer -= delta
	if dieing_timer > 0:
		if Engine.get_frames_drawn() % 5 == 0:
			modulate.a = 0.0
		else:
			modulate.a = 1.0
	else:
		emit_signal("died", position)
		call_deferred("queue_free")


func _try_charge():
	if position.distance_to(Player.position) < detection_range:
		var space_state = get_world_2d().direct_space_state
		var result = space_state.intersect_ray(global_position, Player.global_position, [self], collision_mask)
		if result.collider == Player:
			_set_state_windup()


func _on_EnemyDash_character_died():
	_set_state_dieing()
