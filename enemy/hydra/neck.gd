extends Line2D

var levelNavigation: Navigation2D = null

#onready var line2d = $Neck_v4
export(NodePath) var head_path
export(NodePath) var body_path
var head = null
var death = false

var neck: Array = []

# Called when the node enters the scene tree for the first time.
func _ready():
	yield(get_tree(), "idle_frame")
	var tree = get_tree()
	if tree.has_group("LevelNavigation"):
		levelNavigation = tree.get_nodes_in_group("LevelNavigation")[0]
#		print(levelNavigation)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	head = get_node(head_path)
#	print(head)
#	print(head.global_position)
	
	if head != null and !death:
		generate_neck()
	else:
		var cut = load("res://enemy/hydra/hydra_cut_head.tscn").instance()
		cut.position = points[-1]
		
		if points[-1].x > points[-2].x:
			cut.flip_h = true
		
		add_child(cut)
#		points = []

func generate_neck():
#	print("here")
#	var start = get_node("Body").position
	var start = get_node(body_path).global_position
	var head = get_node(head_path)
#	var head = get_node("../EnemyRange").global_position
#	print(head.)
#	var start = Vector2(478, 539)
#	print(levelNavigation != null)
#	print(head != null)
	if levelNavigation != null and head != null:
#		print("here")
#		print(position)
#		print(start)
		neck = levelNavigation.get_simple_path(start, head.global_position, false)
		points = neck

#func _physics_process(delta):
#	pass
