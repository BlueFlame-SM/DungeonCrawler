extends Camera2D

const screen_size := Vector2(960, 640)
var cur_screen := Vector2(0, 0)

# Called when the node enters the scene tree for the first time.
func _ready():
	set_as_toplevel(true)
	global_position = get_parent().global_position
	_update_screen(cur_screen)
	
func _physics_process(delta):
	var parent_screen : Vector2 = (get_parent().global_position / screen_size).floor()
	if not parent_screen.is_equal_approx(cur_screen):
		_update_screen(parent_screen)
		
func _update_screen(new_screen : Vector2):
	cur_screen = new_screen
	global_position = cur_screen * screen_size + screen_size * 0.5


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
