extends Node

var contadorDiscos = 0

var speedNivelRitmico
var scoreNivelRitmico_1 = 0
var scoreNivelRitmico_2 = 0
var scoreNivelRitmico_3 = 0
var scoreNivelRitmico_4 = 0
var replayNivelRitmico = false
var nivelRitmico

var diccionario_coleccionables = {
	0: ["Bandoneon","«Lo trajo envuelto en una caja, y yo me alegré: creía que eran los patines que le había pedido tantas veces. Fue una decepción, porque en lugar de los patines me encontré con un aparato que no había visto en mi vida» - Piazzolla"],
	1: ["Muñeco de Nonino","«Astor va a llegar lejos. Vale mucho. Sé que cuando se propone hacer una cosa, la hace y bien.» - Nonino"],
	2: ["Avion roto","«¡Qué noche, Charlie! Allí fue mi bautismo con el tango. Primer tango de mi vida y ¡acompañando a Gardel! Jamás lo olvidaré. Al poco tiempo te fuiste con Lepera y tus guitarristas a Hollywood. ¿Te acordás que me mandaste dos telegramas para que me uniera a ustedes con mi bandoneón? Era la primavera del 35 y yo cumplía 14 años. Los viejos no me dieron permiso y el sindicato tampoco. Charlie, ¡me salvé! En vez de tocar el bandoneón estaría tocando el arpa.» - Piazzolla"],
	3: ["Libro de Partituras Parisino","«Ella me enseñó a creer en Astor Piazzolla, en que mi música no era tan mala como yo creía. Yo pensaba que era una basura porque tocaba tangos en un cabaré, y resulta que yo tenía una cosa que se llama estilo.» - Piazzolla"]
}

var coleccionables = [false,false,false,false]
var palancas = [false]

const SAVE_DIR = "user://saves/"
var save_path = "save.txt"
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
			coleccionables = player_data.coleccionables
			palancas = player_data.palancas

func _on_Area2D_Game_Over_body_entered(body):
	PantallaFade.change_scene("res://producto/scenes/NivelPlataforma.tscn")

func addDisco():
	contadorDiscos+=1
	saveGame = false
	
func getDisco():
	return contadorDiscos

func nuevaPartida():
	contadorDiscos = 0
	coleccionables = [false,false,false,false]
	palancas = [false]
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
		score = player_data.scoreNivelRitmico_1
	elif nivel == 2:
		score = player_data.scoreNivelRitmico_2
	elif nivel == 3:
		score = player_data.scoreNivelRitmico_3
	elif nivel == 4:
		score = player_data.scoreNivelRitmico_4
	return score

func get_nivel_ritmico():
	var nivel
	if replayNivelRitmico:
		nivel = nivelRitmico	
	else:
		nivel = getDisco()
	return nivel

func set_nivel_ritmico(nivel):
	nivelRitmico = nivel

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
		"scoreNivelRitmico_4" : scoreNivelRitmico_4,
		"coleccionables" : coleccionables,
		"palancas" : palancas
	}
	return data

func addColeccionable(id):
	coleccionables[id] = true
	print(diccionario_coleccionables[id])
	save_game()
	
	
func get_diccionario_coleccionables():
	return diccionario_coleccionables

func _on_Trampolines_body_shape_entered(body_id, body, body_shape, local_shape):
	$Trampolines._down(local_shape)


func _on_Trampolines_body_shape_exited(body_id, body, body_shape, local_shape):
	$Trampolines._up(local_shape)

func actualizaPalancas(id,valor):
	palancas[id] = valor
	save_game()

func get_palancas():
	return palancas
