extends Control

func _ready():
	
	# Posicion ventana reproduccion
	var screen_size = OS.get_screen_size(OS.get_current_screen())
	var window_size = OS.get_window_size()
	var centered_pos = (screen_size - window_size) / 2
	OS.set_window_position(centered_pos)
	GameHandler.load_game()
	if GameHandler.getDisco() == 0:
		$CanvasLayer/VBoxContainer/Jugar.visible = false

func _on_Jugar_pressed():
	GameHandler.set_transicion("NivelPlataforma")
	PantallaFade.change_scene("res://producto/scenes/FraseTransicion.tscn")

func _on_NuevaPartida_pressed():
	GameHandler.nuevaPartida()
	_on_Jugar_pressed()

func _on_creditos_pressed():
	PantallaFade.change_scene("res://producto/scenes/Final.tscn")
