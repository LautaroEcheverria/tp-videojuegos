extends Control

func _ready():
	$Timer.start()
	$Animacion.play("movimiento")

func _input(event):
	if event.is_action_pressed("mouse") or event is InputEventScreenTouch:
		cambio_Escena()

func _on_Timer_timeout():
	cambio_Escena()
	
func cambio_Escena():
	var creditosMenu = GameHandler.get_creditosMenu()
	if !creditosMenu:
		PantallaFade.change_scene("res://producto/scenes/Plataformas/NivelPlataforma.tscn")
		GameHandler.set_checkpointSave(1)
		GameHandler.creditosMenu = true
		GameHandler.save_game()
	else:
		PantallaFade.change_scene("res://producto/scenes/Inicio.tscn")
		
