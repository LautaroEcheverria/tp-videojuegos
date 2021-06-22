extends Node2D

var score = 0
var combo = 0
var maxCombo = 0

var bien = 0
var muyBien = 0
var excelente = 0
var fallada = 0

var bpm

var song_position = 0.0
var song_position_in_beats = 0
var last_spawned_beat = 0
var sec_per_beat

var spawn_1_beat = 0
var spawn_2_beat = 0
var spawn_3_beat = 1
var spawn_4_beat = 0

var note = load("res://producto/scenes/Ritmo/Note.tscn")
var lane = 0
var rand = 0
var instance
var speed
var nivel
var totalLanes = 3

var gameOverScreen = false

func _ready():
	# Posicion ventana reproduccion
	var screen_size = OS.get_screen_size(OS.get_current_screen())
	var window_size = OS.get_window_size()
	var centered_pos = (screen_size - window_size) / 2
	OS.set_window_position(centered_pos)
	
	randomize()
	#nivel = 1
	nivel = GameHandler.get_nivel_ritmico()
	speed = GameHandler.get_speed_nivel_ritmico()
	bpm = GameHandler.get_BPM(nivel)
	sec_per_beat = 60.0 / bpm
	$Conductor.set_nivel(nivel)
	set_total_lanes(speed)
	set_initial_screen()
	change_sprite_color(nivel)
	if nivel == 1:
		$Conductor.stream = load("res://producto/assets/music/1_oblivion.mp3")
		#$Conductor.stream = load("res://producto/assets/music/prueba.mp3")
		$NombreCancion.text = "Oblivion - Astor Piazzolla (Nivel 1)"
	elif nivel == 2:
		$Conductor.stream = load("res://producto/assets/music/2_violentango.mp3")
		#$Conductor.stream = load("res://producto/assets/music/prueba.mp3")
		$NombreCancion.text = "Violentango - Astor Piazzolla (Nivel 2)"
	elif nivel == 3:
		$Conductor.stream = load("res://producto/assets/music/3_libertango.mp3")
		#$Conductor.stream = load("res://producto/assets/music/prueba.mp3")
		$NombreCancion.text = "Libertango - Astor Piazzolla (Nivel 3)"
	elif nivel == 4:
		$Conductor.stream = load("res://producto/assets/music/4_adiosnonino.mp3")
		#$Conductor.stream = load("res://producto/assets/music/prueba.mp3")
		$NombreCancion.text = "Adios Nonino - Astor Piazzolla (Nivel 4)"
	$Conductor.play_with_beat_offset(2)
	
func _input(event):
	if event.is_action("ui_cancel"):
		PantallaFade.change_scene("res://producto/scenes/Plataformas/NivelPlataforma.tscn")
		GameHandler.replayNivelRitmico = false
	if event.is_action("mouse") and gameOverScreen:
		PantallaFade.change_scene("res://producto/scenes/Plataformas/NivelPlataforma.tscn")
		
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

func _spawn_notes(to_spawn):
	if to_spawn > 0:
		if totalLanes == 3:
			lane = randi() % 3 + 1
		elif totalLanes == 4:
			lane = randi() % 4 + 1
		elif totalLanes == 5:
			lane = randi() % 5 + 1
		instance = note.instance()
		instance.initialize(lane,totalLanes) 
		instance.set_speed(speed)
		instance.set_color(nivel,lane,totalLanes)
		add_child(instance)

func get_score():
	return score

func set_score(value):
	if value == 0:
		fallada += 1
		$Score2.text = "..FALLADA.."
		$Score2.modulate = Color.red
		combo = 0
	if value == 1:
		bien += 1
		$Score2.text = "..BIEN.."
		$Score2.modulate = Color.yellow
		combo = 0
	elif value == 2:
		muyBien += 1
		$Score2.text = "..MUY BIEN.."
		$Score2.modulate = Color.orange
		combo = 0
	elif value == 3:
		excelente += 1
		$Score2.text = "..EXCELENTE!.."
		$Score2.modulate = Color.green
		combo += 1
	if combo >= 10:
		score += value*4
		$Score.text = "Puntaje: " + str(score)
		if totalLanes < 5:
			$ComboLabel.text = "Rey del Tango!"
		else:
			$ComboLabel.text = "Rey del\nTango!"
		$ComboMultiplicador.text = "(x4)"
	elif combo >= 5 and combo < 10:
		score += value*2
		$Score.text = "Puntaje: " + str(score)
		$CPUParticles2D.emitting = true
		$CPUParticles2D2.emitting = true
		$CPUParticles2D3.emitting = true
		$CPUParticles2D4.emitting = true
		if totalLanes < 5:
			$ComboLabel.text = "Hora Combo!"
		else:
			$ComboLabel.text = "Hora\nCombo!"
		$ComboMultiplicador.text = "(x2)"
	else:
		score += value
		if score != 0:
			$Score.text = "Puntaje: " + str(score)
		$CPUParticles2D.emitting = false
		$CPUParticles2D2.emitting = false
		$CPUParticles2D3.emitting = false
		$CPUParticles2D4.emitting = false
		$ComboLabel.text = ""
		$ComboMultiplicador.text = ""
	if combo > maxCombo and combo >= 5:
		maxCombo = combo

func set_initial_screen():
	if totalLanes > 3:
		$Sprite4.visible = true
		$Sprite5.visible = true
		if totalLanes == 4:
			$Sprite2.visible = false
			$Sprite4.position.x = 573
			$Sprite5.position.x = 707
		elif totalLanes == 5:
			$Sprite.position.x = 400
			$Sprite3.position.x = 880
			$Sprite4.position.x = 520
			$Sprite5.position.x = 760
			$Score.rect_position.x = 50
			$Score2.rect_position.x = 992
			$ComboMultiplicador.rect_position.x = 56
			$ComboLabel.rect_position.x = 969

func change_sprite_color(value):
	if value == 1:
		$Sprite.modulate = Color("#80ffffff")
		$Sprite3.modulate = Color("#80ffffff")
		if totalLanes == 3 or totalLanes == 5:
			$Sprite2.modulate = Color("#80ffffff")
		if totalLanes >= 4:
			$Sprite4.modulate = Color("#80ffffff")
			$Sprite5.modulate = Color("#80ffffff")
	elif value == 2:
		$Sprite.set_texture(load("res://producto/assets/img/Ritmo/Note2.png"))
		$Sprite3.set_texture(load("res://producto/assets/img/Ritmo/Note2.png"))
		$Sprite.modulate = Color("#7bffffff")
		$Sprite3.modulate = Color("#7bffffff")
		$Sprite.scale.x = 0.198
		$Sprite.scale.y = 0.208
		$Sprite3.scale.x = 0.198
		$Sprite3.scale.y = 0.208
		if totalLanes == 3 or totalLanes == 5:
			$Sprite2.set_texture(load("res://producto/assets/img/Ritmo/Note2.png"))
			$Sprite2.modulate = Color("#7bffffff")
			$Sprite2.scale.x = 0.198
			$Sprite2.scale.y = 0.208
		if totalLanes >= 4:
			$Sprite4.set_texture(load("res://producto/assets/img/Ritmo/Note2.png"))
			$Sprite4.modulate = Color("#7bffffff")
			$Sprite4.scale.x = 0.198
			$Sprite4.scale.y = 0.208
			$Sprite5.set_texture(load("res://producto/assets/img/Ritmo/Note2.png"))
			$Sprite5.modulate = Color("#7bffffff")
			$Sprite5.scale.x = 0.198
			$Sprite5.scale.y = 0.208
	elif value == 3:
		$Sprite.modulate = Color("#8600ff00")
		$Sprite3.modulate = Color("#8600ff00")
		if totalLanes == 3 or totalLanes == 5:
			$Sprite2.modulate = Color("#8600ff00")
		if totalLanes >= 4:
			$Sprite4.modulate = Color("#8600ff00")
			$Sprite5.modulate = Color("#8600ff00")
	elif value == 4:
		if totalLanes == 3:
			$Sprite.modulate = Color("#80ffffff")
			$Sprite2.set_texture(load("res://producto/assets/img/Ritmo/Note2.png"))
			$Sprite2.modulate = Color("#7bffffff")
			$Sprite2.scale.x = 0.198
			$Sprite2.scale.y = 0.208
			$Sprite3.modulate = Color("#8600ff00")	
		elif totalLanes == 4:
			$Sprite.modulate = Color("#80ffffff")
			$Sprite3.modulate = Color("#80ffffff")
			$Sprite4.set_texture(load("res://producto/assets/img/Ritmo/Note2.png"))
			$Sprite4.modulate = Color("#7bffffff")
			$Sprite4.scale.x = 0.198
			$Sprite4.scale.y = 0.208
			$Sprite5.modulate = Color("#8600ff00")
		elif totalLanes == 5:
			$Sprite.modulate = Color("#80ffffff")
			$Sprite2.set_texture(load("res://producto/assets/img/Ritmo/Note2.png"))
			$Sprite2.modulate = Color("#7bffffff")
			$Sprite2.scale.x = 0.198
			$Sprite2.scale.y = 0.208
			$Sprite3.modulate = Color("#80ffffff")
			$Sprite4.modulate = Color("#8600ff00")
			$Sprite5.modulate = Color("#8600ff00")

func change_screen_game_over():
	$Score.visible = false
	$Score2.visible = false
	$ComboLabel.visible = false
	$ComboMultiplicador.visible = false
	$CPUParticles2D.emitting = false
	$CPUParticles2D2.emitting = false
	$CPUParticles2D3.emitting = false
	$CPUParticles2D4.emitting = false
	$Sprite.visible = false
	$Sprite2.visible = false
	$Sprite3.visible = false
	$Sprite4.visible = false
	$Sprite5.visible = false
	$GameOver/Ok.modulate = Color.yellow
	$GameOver/Good.modulate = Color.orange
	$GameOver/Perfect.modulate = Color.green
	$GameOver/Missed.modulate = Color.red
	$GameOver/ScoreTotal.text += str(score)
	$GameOver/Ok.text += str(bien)
	$GameOver/Good.text += str(muyBien)
	$GameOver/Perfect.text += str(excelente)
	$GameOver/Missed.text += str(fallada)
	$GameOver/MaxCombo.text += str(maxCombo)
	$GameOver.visible = true
	$NombreCancion.visible = true
	gameOverScreen = true

func _button_entered(value,pos_x):
	if value:
		if totalLanes == 3 or totalLanes == 4:
			if pos_x == 440:
				if nivel == 1 or nivel == 2 or nivel == 4:
					$Sprite.modulate = Color("#ffffff")
				elif nivel == 3:
					$Sprite.modulate = Color("#00ff0a") 
			elif pos_x == 840:
				if nivel == 1 or nivel == 2:
					$Sprite3.modulate = Color("#ffffff")
				elif nivel == 3:
					$Sprite3.modulate = Color("#00ff0a")
				elif nivel == 4:
					if totalLanes == 3:
						$Sprite3.modulate = Color("#00ff0a")
					else:
						$Sprite3.modulate = Color("#ffffff")
			if totalLanes == 3:
				if pos_x == 640:
					if nivel == 1 or nivel == 2 or nivel == 4:
						$Sprite2.modulate = Color("#ffffff")
					elif nivel == 3:
						$Sprite2.modulate = Color("#00ff0a")
			else:
				if pos_x == 573:
					if nivel == 1 or nivel == 2 or nivel == 4:
						$Sprite4.modulate = Color("#ffffff")
					elif nivel == 3:
						$Sprite4.modulate = Color("#00ff0a") 
				elif pos_x == 707:
					if nivel == 1 or nivel == 2:
						$Sprite5.modulate = Color("#ffffff")
					elif nivel == 3 or nivel == 4:
						$Sprite5.modulate = Color("#00ff0a") 
		elif totalLanes == 5:
			if pos_x == 400:
				if nivel == 1 or nivel == 2 or nivel == 4:
					$Sprite.modulate = Color("#ffffff")
				elif nivel == 3:
					$Sprite.modulate = Color("#00ff0a") 
			elif pos_x == 520:
				if nivel == 1 or nivel == 2:
					$Sprite4.modulate = Color("#ffffff")
				elif nivel == 3 or nivel == 4:
					$Sprite4.modulate = Color("#00ff0a") 
			elif pos_x == 640:
				if nivel == 1 or nivel == 2 or nivel == 4:
					$Sprite2.modulate = Color("#ffffff")
				elif nivel == 3:
					$Sprite2.modulate = Color("#00ff0a") 
			elif pos_x == 760:
				if nivel == 1 or nivel == 2:
					$Sprite5.modulate = Color("#ffffff")
				elif nivel == 3 or nivel == 4:
					$Sprite5.modulate = Color("#00ff0a")
			elif pos_x == 880:
				if nivel == 1 or nivel == 2 or nivel == 4:
					$Sprite3.modulate = Color("#ffffff")
				elif nivel == 3:
					$Sprite3.modulate = Color("#00ff0a") 

func  set_total_lanes(value):
	if value == 1:
		totalLanes = 3
	elif value == 2:
		totalLanes = 4
	elif value == 3:
		totalLanes = 5

func _on_Area2D_area_exited(area):
	change_sprite_color(nivel)

func _on_Area2D2_area_exited(area):
	if totalLanes != 4:
		change_sprite_color(nivel)

func _on_Area2D3_area_exited(area):
	change_sprite_color(nivel)

func _on_Area2D4_area_exited(area):
	if totalLanes >= 4:
		change_sprite_color(nivel)

func _on_Area2D5_area_exited(area):
	if totalLanes >= 4:
		change_sprite_color(nivel)

# Fin del nivel
func _on_Conductor_finished():
	$Timer.start()

# Espera 6 seg hasta terminar por delay con AudioStreamPlayer
func _on_Timer_timeout():
	change_screen_game_over()
	GameHandler.set_score_nivel_ritmico(score,nivel)
	GameHandler.save_game()
	GameHandler.replayNivelRitmico = false
	print("Nivel " + str(nivel) + ": guardado")
	$Timer2.start()

# Muestra pantalla de puntos durante 6 seg y vuelve a plataforma
func _on_Timer2_timeout():
	PantallaFade.change_scene("res://producto/scenes/Plataformas/NivelPlataforma.tscn")
