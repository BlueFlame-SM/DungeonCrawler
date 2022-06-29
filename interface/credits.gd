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
	titleTimer = Timer.new()
	add_child(titleTimer)
	titleTimer.connect("timeout", self, "_on_timeout")
	titleTimer.wait_time = 2.0
	titleTimer.one_shot = true
	titleTimer.start()



func _process(delta):
	var scroll_speed = base_speed * delta
	
	if section_next:
		section_timer += delta * speed_up_multiplier if speed_up else delta
		if section_timer >= section_time:
			section_timer -= section_time
			
			if credits.size() > 0:
				started = true
				section = credits.pop_front()
				curr_line = 0
				add_line()
	
	else:
		line_timer += delta * speed_up_multiplier if speed_up else delta
		if line_timer >= line_time:
			line_timer -= line_time
			add_line()
	
	if speed_up:
		scroll_speed *= speed_up_multiplier
	
	if lines.size() > 0:
		for l in lines:
			l.rect_position.y -= scroll_speed
			if l.rect_position.y < -l.get_line_height():
				lines.erase(l)
				l.queue_free()
	elif started:
		finish()


func finish():
	if not finished:
		finished = true
		GlobalVars.level_type = "main_menu"
		LevelSwitcher.goto_scene("res://interface/main_menu.tscn", false)


func add_line():
	var new_line = line.duplicate()
	new_line.text = section.pop_front()
	lines.append(new_line)
	if curr_line == 0:
		new_line.add_color_override("font_color", title_color)
	$CreditsContainer.add_child(new_line)
	
	if section.size() > 0:
		curr_line += 1
		section_next = false
	else:
		section_next = true


func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		finish()
	if event.is_action_pressed("ui_down") and !event.is_echo():
		speed_up = true
	if event.is_action_released("ui_down") and !event.is_echo():
		speed_up = false
		
		
func _on_timeout():
	tween.interpolate_property(messageLabel, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), 0.6, tween.TRANS_LINEAR, tween.EASE_IN)
	tween.start()
