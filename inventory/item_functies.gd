extends Character

func damage(value):
	_set_damage(value)

func attack_speed(value):
	_set_cooldown_time(value * 100)

func attack_type():
	pass

func range_weapon(value):
	return Vector2(value, value)

func knockback():
	pass

func poison():
	pass

func bleed():
	pass

func slow_enemy():
	pass

func speed_change():
	pass

func stun_change():
	pass

func stack_size():
	pass

func description():
	pass
