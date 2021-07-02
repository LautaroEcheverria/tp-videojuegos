extends Control

func _ready():
	$Timer.start()
	$Animacion.play("movimiento")
	GameHandler.gameOver = true
	GameHandler.save_game()

func _input(event):
	if event.is_action_pressed("mouse") or event is InputEventScreenTouch:
		cambio_Escena()

func _on_Timer_timeout():
	cambio_Escena()
	
func cambio_Escena():
	if GameHandler.contadorDiscos :
		PantallaFade.change_scene("res://producto/scenes/Plataformas/NivelPlataforma.tscn")
	else:
		PantallaFade.change_scene("res://producto/scenes/Inicio.tscn")
		
