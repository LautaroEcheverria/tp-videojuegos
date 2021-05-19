extends Control

func _ready():
	
	# Posicion ventana reproduccion
	var screen_size = OS.get_screen_size(OS.get_current_screen())
	var window_size = OS.get_window_size()
	var centered_pos = (screen_size - window_size) / 2
	OS.set_window_position(centered_pos)

func _on_Salir_pressed():
	get_tree().quit()

func _on_Jugar_pressed():
	get_tree().change_scene("res://producto/scenes/Plataforma1.tscn")
