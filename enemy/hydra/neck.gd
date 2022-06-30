# Source: https://github.com/IvessJohn/basic-pathfinding-Godot/blob/main/Enemy.gd

# Generate a neck between the head node and body node.

extends Line2D

# Map used for navigation. 
var levelNavigation: Navigation2D = null

# Paths to the head and body node.
export(NodePath) var head_path
export(NodePath) var body_path


var head = null
var death = false

var neck: Array = []

# Called when the node enters the scene tree for the first time.
func _ready():
	""" Load in level navigation. """
	yield(get_tree(), "idle_frame")
	var tree = get_tree()
	if tree.has_group("LevelNavigation"):
		levelNavigation = tree.get_nodes_in_group("LevelNavigation")[0]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	""" Update the neck position every delta. If the head is gone, 
		place a cut head sprite at the end of the current neck.
	"""
	head = get_node(head_path)
	
	if head != null and !death:
		generate_neck()
	else:
		var cut = load("res://enemy/hydra/hydra_cut_head.tscn").instance()
		cut.position = points[-1]
		
		if points[-1].x > points[-2].x:
			cut.flip_h = true
		
		add_child(cut)


func generate_neck():
	""" Navigate a path between the head and body node and save the path 
		to the neck array.
	"""
	var start = get_node(body_path).global_position
	var head = get_node(head_path)

	if levelNavigation != null and head != null:
		neck = levelNavigation.get_simple_path(start, head.global_position, false)
		points = neck
