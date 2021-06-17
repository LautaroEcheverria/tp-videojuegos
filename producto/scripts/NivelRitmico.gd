extends Node2D

var score = 0
var combo = 0

var ok = 0
var good = 0
var perfect = 0
var missed = 0

var bpm = 112

var song_position = 0.0
var song_position_in_beats = 0
var last_spawned_beat = 0
var sec_per_beat = 60.0 / bpm

var spawn_1_beat = 0
var spawn_2_beat = 0
var spawn_3_beat = 1
var spawn_4_beat = 0

var note = load("res://producto/scenes/Note.tscn")
var lane = 0
var rand = 0
var instance
export var speed = 3
export var nivel = 4

func _ready():
	nivel = GameHandler.getDisco()
	# Posicion ventana reproduccion
	var screen_size = OS.get_screen_size(OS.get_current_screen())
	var window_size = OS.get_window_size()
	var centered_pos = (screen_size - window_size) / 2
	OS.set_window_position(centered_pos)
	
	randomize()
	if nivel == 1:
		$Conductor.stream = load("res://producto/assets/music/1_oblivion.mp3")
		#$Conductor.stream = load("res://producto/assets/music/prueba.mp3")
	elif nivel == 2:
		$Conductor.stream = load("res://producto/assets/music/2_violentango.mp3")
		#$Conductor.stream = load("res://producto/assets/music/prueba.mp3")
	elif nivel == 3:
		$Conductor.stream = load("res://producto/assets/music/3_libertango.mp3")
		#$Conductor.stream = load("res://producto/assets/music/prueba.mp3")
	elif nivel == 4:
		$Conductor.stream = load("res://producto/assets/music/4_adiosnonino.mp3")
		#$Conductor.stream = load("res://producto/assets/music/prueba.mp3")
	$Conductor.play_with_beat_offset(2)
	change_sprite_color(nivel)
	
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
		instance.initialize(lane) 
		instance.set_speed(speed)
		instance.set_color(nivel,lane)
		add_child(instance)

func set_score(value):
	if value == 0:
		missed += 1
		$Score2.text = "..MISSED.."
		$Score2.modulate = Color.red
		combo = 0
	if value == 1:
		ok += 1
		$Score2.text = "..OK.."
		$Score2.modulate = Color.yellow
		combo = 0
	elif value == 2:
		good += 1
		$Score2.text = "..GOOD.."
		$Score2.modulate = Color.orange
		combo = 0
	elif value == 3:
		perfect += 1
		$Score2.text = "..PERFECT!.."
		$Score2.modulate = Color.green
		combo += 1
	if combo >= 10:
		score += value*4
		$Score.text = "Score: " + str(score)
		$ComboLabel.text = "Tango master!"
		$ComboMultiplicador.text = "(x4)"
		$CPUParticles2D.amount *= 1.7
		$CPUParticles2D2.amount *= 1.7
		$CPUParticles2D3.amount *= 1.7
		$CPUParticles2D4.amount *= 1.7
	elif combo >= 5 and combo < 10:
		score += value*2
		$Score.text = "Score: " + str(score)
		$CPUParticles2D.emitting = true
		$CPUParticles2D2.emitting = true
		$CPUParticles2D3.emitting = true
		$CPUParticles2D4.emitting = true
		$ComboLabel.text = "Combo time!"
		$ComboMultiplicador.text = "(x2)"
	else:
		score += value
		if score != 0:
			$Score.text = "Score: " + str(score)
		$CPUParticles2D.emitting = false
		$CPUParticles2D2.emitting = false
		$CPUParticles2D3.emitting = false
		$CPUParticles2D4.emitting = false
		$ComboLabel.text = ""
		$ComboMultiplicador.text = ""

func change_sprite_color(value):
	if value == 1:
		$Sprite.modulate = Color("#80ffffff")
		$Sprite2.modulate = Color("#80ffffff")
		$Sprite3.modulate = Color("#80ffffff")
	elif value == 2:
		$Sprite.set_texture(load("res://producto/assets/img/Ritmo/Note2.png"))
		$Sprite2.set_texture(load("res://producto/assets/img/Ritmo/Note2.png"))
		$Sprite3.set_texture(load("res://producto/assets/img/Ritmo/Note2.png"))
		$Sprite.modulate = Color("#7bffffff")
		$Sprite2.modulate = Color("#7bffffff")
		$Sprite3.modulate = Color("#7bffffff")
		$Sprite.scale.x = 0.198
		$Sprite.scale.y = 0.208
		$Sprite2.scale.x = 0.198
		$Sprite2.scale.y = 0.208
		$Sprite3.scale.x = 0.198
		$Sprite3.scale.y = 0.208
	elif value == 3:
		$Sprite.modulate = Color("#8600ff00")
		$Sprite2.modulate = Color("#8600ff00")
		$Sprite3.modulate = Color("#8600ff00")
	elif value == 4:
		$Sprite.modulate = Color("#80ffffff")
		$Sprite2.set_texture(load("res://producto/assets/img/Ritmo/Note2.png"))
		$Sprite2.modulate = Color("#7bffffff")
		$Sprite2.scale.x = 0.198
		$Sprite2.scale.y = 0.208
		$Sprite3.modulate = Color("#8600ff00")

func _button_entered(value,pos_x):
	if value:
		if pos_x == 440:
			if nivel == 1 or nivel == 2 or nivel == 4:
				$Sprite.modulate = Color("#ffffff")
			elif nivel == 3:
				$Sprite.modulate = Color("#00ff0a") 
		elif pos_x == 640:
			if nivel == 1 or nivel == 2 or nivel == 4:
				$Sprite2.modulate = Color("#ffffff")
			elif nivel == 3:
				$Sprite2.modulate = Color("#00ff0a") 
		elif pos_x == 840:
			if nivel == 1 or nivel == 2:
				$Sprite3.modulate = Color("#ffffff")
			elif nivel == 3 or nivel == 4:
				$Sprite3.modulate = Color("#00ff0a")

func _on_Area2D_area_exited(area):
	change_sprite_color(nivel)

func _on_Area2D2_area_exited(area):
	change_sprite_color(nivel)

func _on_Area2D3_area_exited(area):
	change_sprite_color(nivel)


func _on_Conductor_finished():
	#Fin del nivel
	PantallaFade.change_scene("res://producto/scenes/NivelPlataforma.tscn")
