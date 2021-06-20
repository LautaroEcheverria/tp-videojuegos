extends Node

var contadorDiscos = 0

var speedNivelRitmico
var scoreNivelRitmico_1 = 0
var scoreNivelRitmico_2 = 0
var scoreNivelRitmico_3 = 0
var scoreNivelRitmico_4 = 0

const SAVE_DIR = "user://saves/"
var save_path = "save.dat"
var saveGame = false
var player_data

func _ready():
	pass

func save_game():
	var dir = Directory.new()
	if !dir.dir_exists(SAVE_DIR):
		dir.make_dir_recursive(SAVE_DIR)
	var file = File.new()
	var error = file.open(save_path, File.WRITE)
	if error == OK:
		file.store_var(save_game_data())
		file.close()

func load_game():
	var file = File.new()
	if file.file_exists(save_path):
		var error = file.open(save_path, File.READ)
		if error == OK:
			player_data = file.get_var()
			print(player_data)
			file.close()
			contadorDiscos = player_data.contadorDiscos

func _on_Area2D_Game_Over_body_entered(body):
	PantallaFade.change_scene("res://producto/scenes/NivelPlataforma.tscn")

func _on_Palanca_body_entered(body):
	if $Robot.contadorDiscos >= 2:
		
		$"Sombra Secretos/Sombra de descubrimiento Exterior".visible = false

func addDisco():
	contadorDiscos+=1
	saveGame = false
	
func getDisco():
	return contadorDiscos

func nuevaPartida():
	contadorDiscos = 0
	save_game()
	
func set_speed_nivel_ritmico(value):
	speedNivelRitmico = value
	
func get_speed_nivel_ritmico():
	return speedNivelRitmico

func set_score_nivel_ritmico(score,nivel):
	if nivel == 1:
		scoreNivelRitmico_1 = score
	elif nivel == 2:
		scoreNivelRitmico_2 = score
	elif nivel == 3:
		scoreNivelRitmico_3 = score
	elif nivel == 4:
		scoreNivelRitmico_4 = score
		
func get_score_nivel_ritmico(nivel):
	var score
	if nivel == 1:
		score = scoreNivelRitmico_1
	elif nivel == 2:
		score = scoreNivelRitmico_2
	elif nivel == 3:
		score = scoreNivelRitmico_3
	elif nivel == 4:
		score = scoreNivelRitmico_4
	return score

func save_game_data():
	var pos_x
	var pos_y 
	if contadorDiscos == 1:
		pos_x = 1771
		pos_y = 481
	elif contadorDiscos == 2:
		pos_x = 4927
		pos_y = 481
	var data = {
		"contadorDiscos" : contadorDiscos,
		"pos_x" : pos_x,
		"pos_y" : pos_y,
		"scoreNivelRitmico_1" : scoreNivelRitmico_1,
		"scoreNivelRitmico_2" : scoreNivelRitmico_2,
		"scoreNivelRitmico_3" : scoreNivelRitmico_3,
		"scoreNivelRitmico_4" : scoreNivelRitmico_4
	}
	return data
