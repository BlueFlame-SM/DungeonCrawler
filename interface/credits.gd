"""
Code for the end-credit screen. This screen is shown when the player has
beaten the end-boss. It shows a 'Thank you for playing' message, and rolls
the credits.

section_time: The amount of time one section is shown in seconds.
line_time: The amount of time one line is shown in seconds.
base_speed: The base speed of the rolling of the credits.
speed_up_multiplier: The value with which the speed must be multiplied when
the player manually speeds up the rolling of credits.
title_color: The colors of the title lines.
scroll_speed: The speed of the rolling credits.
line: The starting position of the lines.
started: Initially false, true when credits started.
finished: Initially false, true when credits finished.
section: The current section shown.
section_next: True when the next section can be rolled, false if a section
is still rolling.
section_timer: Timer for the duration of a section in seconds.
line_timer: Timer for the duration of a line in seconds.
curr_line: The current line moving.
lines: The list of lines.
titleTimer: The timer for showing a message at the start of the credit screen.
messageLabel: The label containing the starting message.
tween: The tween node needed for fading out the message.
credits: The actual text of the credits.
"""


# Source: https://github.com/benbishopnz/godot-credits


extends Node2D


const section_time := 2.0
const line_time := 0.3
const base_speed := 100
const speed_up_multiplier := 10.0
const title_color := Color( 0.145098, 0.313726, 0.305882, 1 )

var scroll_speed := base_speed
var speed_up := false

onready var line := $CreditsContainer/Line
var started := false
var finished := false

var section
var section_next := true
var section_timer := 0.0
var line_timer := 0.0
var curr_line := 0
var lines := []

var titleTimer = null
onready var messageLabel = $CreditsContainer/Message
onready var tween = $Tween

var credits = [
	[
		"A game by Team STYX"
	],[
		"Programming",
		"Misha Oberski",
		"Margot Pauelsen",
		"Jasper Bruin",
		"Marijn Versluis",
		"Luuk den Hartog",
		"Tika van Bennekum",
		"Timo Post",
		"Lisanne Aerts",
		"Nora Silven",
		"Kelly de Dood"
	],[
		"Art",
		"Nina The",
		"Kelly de Dood",
		"Nora Silven"
	],[
		"Music",
		"Musician Name"
	],[
		"Testers",
		"Misha Oberski",
		"Margot Pauelsen",
		"Jasper Bruin",
		"Marijn Versluis",
		"Luuk den Hartog",
		"Tika van Bennekum",
		"Timo Post",
		"Lisanne Aerts",
		"Nora Silven",
		"Kelly de Dood"
	],[
		"Tools used",
		"Developed with Godot Engine",
		"https://godotengine.org/license",
		"",
		"Art created with My Favourite Art Program",
		"https://myfavouriteartprogram.com"
	],[
		"Special thanks",
		"dr. Ana Oprescu",
		"Kyrian Maat MSc"
	]
]


func _ready():
	"""
	The timer for showing the thank you message is initialized and started.
	"""
	Player.hide()
	Player.get_child(4).get_child(1).hide()
	Gui.get_child(0).hide()
	titleTimer = Timer.new()
	add_child(titleTimer)
	titleTimer.connect("timeout", self, "_on_timeout")
	titleTimer.wait_time = 2.0
	titleTimer.one_shot = true
	titleTimer.start()


func _process(delta):
	"""
	If there are credits left to roll, the next line is loaded. The speed is
	adjusted when the player presses the down arrow. If the credits are done,
	the screen finishes.
	
	delta: The duration of one tick.
	"""
	var scroll_speed = base_speed * delta
	
	if section_next:
		# Update the section timer.
		section_timer += delta * speed_up_multiplier if speed_up else delta
	
		# If the section is done, reset the section timer.
		if section_timer >= section_time:
			section_timer -= section_time
			
			# If there are still credits left, the next section is started.
			if credits.size() > 0:
				started = true
				section = credits.pop_front()
				curr_line = 0
				add_line()
	
	else:
		# Update the line timer.
		line_timer += delta * speed_up_multiplier if speed_up else delta

		# If the line is done, reset the line timer.
		if line_timer >= line_time:
			line_timer -= line_time
			add_line()
	
	# If the user presses the down arrow, the speed is increased.
	if speed_up:
		scroll_speed *= speed_up_multiplier
	
	# The line is removed when it is done rolling.
	if lines.size() > 0:
		for l in lines:
			l.rect_position.y -= scroll_speed
			if l.rect_position.y < -l.get_line_height():
				lines.erase(l)
				l.queue_free()
	elif started:
		finish()


func finish():
	"""
	Finish the rolling credits, and switches back to the main menu.
	"""
	if not finished:
		finished = true
		GlobalVars.level_type = "main_menu"
		LevelSwitcher.goto_scene("res://interface/main_menu.tscn", false)


func add_line():
	"""
	Adds a line to be rolled from the bottom to the top.
	"""
	# The new line is made.
	var new_line = line.duplicate()
	new_line.text = section.pop_front()
	lines.append(new_line)

	# If the line is a title, the title color is used.
	if curr_line == 0:
		new_line.add_color_override("font_color", title_color)
	$CreditsContainer.add_child(new_line)
	
	# If the section is not done, update number of lines.
	if section.size() > 0:
		curr_line += 1
		section_next = false
	else:
		section_next = true


func _unhandled_input(event):
	"""
	When the player presses the down arrow, the rolling credits speed up.
	
	event: The unhandled input event.
	"""
	# If the player presses ESC, the credits finish.
	if event.is_action_pressed("ui_cancel"):
		finish()
	# If the player holds the the down arrow, the rolling speeds up.
	if event.is_action_pressed("ui_down") and !event.is_echo():
		speed_up = true
	# If the player releases the down arrow, the speedup disappears.
	if event.is_action_released("ui_down") and !event.is_echo():
		speed_up = false
		
		
func _on_timeout():
	"""
	When the message was shown for long enough, it is faded out.
	"""
	tween.interpolate_property(messageLabel, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), 0.6, tween.TRANS_LINEAR, tween.EASE_IN)
	tween.start()
