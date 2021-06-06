extends Control

func _ready():
	
	# Posicion ventana reproduccion
	var screen_size = OS.get_screen_size(OS.get_current_screen())
	var window_size = OS.get_window_size()
	var centered_pos = (screen_size - window_size) / 2
	OS.set_window_position(centered_pos)

func _on_Button_Enter_pressed():
	get_tree().change_scene("res://producto/scenes/NivelRitmico.tscn")

func _on_Button_Exit_pressed():
	get_tree().change_scene("res://producto/scenes/NivelPlataforma.tscn")
