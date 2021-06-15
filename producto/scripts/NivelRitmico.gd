extends Node2D

var score = 0
var combo = 1

var ok = 0
var good = 0
var perfect = 0
var value_last_note = 0

var bpm = 112

var song_position = 0.0
var song_position_in_beats = 0
var last_spawned_beat = 0
var sec_per_beat = 60.0 / bpm

var spawn_1_beat = 0
var spawn_2_beat = 0
var spawn_3_beat = 1
var spawn_4_beat = 0

var lane = 0
var rand = 0
var note = load("res://producto/scenes/Note.tscn")
var instance

func _ready():
	# Posicion ventana reproduccion
	var screen_size = OS.get_screen_size(OS.get_current_screen())
	var window_size = OS.get_window_size()
	var centered_pos = (screen_size - window_size) / 2
	OS.set_window_position(centered_pos)
	
	randomize()
	$Conductor.play_with_beat_offset(2)
	
func _input(event):
	if event.is_action("ui_cancel"):
		get_tree().change_scene("res://producto/scenes/NivelPlataforma.tscn")
		
func _on_Conductor_measure(position):
	if position == 1:
		_spawn_notes(spawn_1_beat)
	elif position == 2:
		_spawn_notes(spawn_2_beat)
	elif position == 3:
		_spawn_notes(spawn_3_beat)
	elif position == 4:
		_spawn_notes(spawn_4_beat)

func _on_Conductor_beat(position):
	song_position_in_beats = position
	if song_position_in_beats > 36:
		spawn_1_beat = 1
		spawn_2_beat = 1
		spawn_3_beat = 0
		spawn_4_beat = 0
	if song_position_in_beats > 98:
		spawn_1_beat = 1
		spawn_2_beat = 0
		spawn_3_beat = 1
		spawn_4_beat = 0
	if song_position_in_beats > 132:
		spawn_1_beat = 0
		spawn_2_beat = 1
		spawn_3_beat = 0
		spawn_4_beat = 1
	if song_position_in_beats > 162:
		spawn_1_beat = 1
		spawn_2_beat = 0
		spawn_3_beat = 0
		spawn_4_beat = 1
	if song_position_in_beats > 194:
		spawn_1_beat = 0
		spawn_2_beat = 0
		spawn_3_beat = 1
		spawn_4_beat = 1
	if song_position_in_beats > 228:
		spawn_1_beat = 0
		spawn_2_beat = 1
		spawn_3_beat = 0
		spawn_4_beat = 1
	if song_position_in_beats > 258:
		spawn_1_beat = 1
		spawn_2_beat = 0
		spawn_3_beat = 1
		spawn_4_beat = 1
	if song_position_in_beats > 288:
		spawn_1_beat = 0
		spawn_2_beat = 1
		spawn_3_beat = 0
		spawn_4_beat = 1
	if song_position_in_beats > 322:
		spawn_1_beat = 1
		spawn_2_beat = 1
		spawn_3_beat = 1
		spawn_4_beat = 1
	if song_position_in_beats > 388:
		spawn_1_beat = 1
		spawn_2_beat = 0
		spawn_3_beat = 0
		spawn_4_beat = 0
	if song_position_in_beats > 396:
		spawn_1_beat = 0
		spawn_2_beat = 0
		spawn_3_beat = 0
		spawn_4_beat = 0
	if song_position_in_beats > 404:
		pass
	#	Pantalla finalización y volver a plataforma
	# 	Mostrar variables ok, good, perfect, score total

func _spawn_notes(to_spawn):
	if to_spawn > 0:
		lane = randi() % 3 + 1
		instance = note.instance()
		instance.initialize(lane,2) # Setear speed nivel
		add_child(instance)
	if to_spawn > 1:
		while rand == lane:
			rand = randi() % 3 + 1
		lane = rand
		instance = note.instance()
		instance.initialize(lane,2) # Setear speed nivel
		add_child(instance) 

func set_score(value):
	if combo >= 20:
		score += value*4
		$Score.text = "Score: " + str(score) + " (x4)"
	elif combo >= 10 and combo < 20:
		score += value*2
		$Score.text = "Score: " + str(score) + " (x2)"
	else:
		score += value
		$Score.text = "Score: " + str(score)
	if value == 1:
		ok += 1
		$Score2.text = "OK"
		$Score2.modulate = Color(227,21,21) # No anda
		$Score2.add_color_override("font_color",Color(227,21,21)) # No anda
		value_last_note = 1
		combo = 1
	elif value == 2:
		good += 1
		$Score2.text = "GOOD"
		$Score2.modulate = Color(238,234,3) # No anda
		$Score2.add_color_override("font_color",Color(238,234,3)) # No anda
		value_last_note = 2
		combo = 1
	elif value == 3:
		perfect += 1
		$Score2.text = "PERFECT!"
		$Score2.modulate = Color(15,238,3) # No anda
		$Score2.add_color_override("font_color",Color(15,238,3)) # No anda
		if value_last_note == 3:
			combo += 1
		value_last_note = 3
