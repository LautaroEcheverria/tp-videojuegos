extends Control

func _ready():
	$Timer.start()
	GameHandler.gameOver = true
	GameHandler.save_game()

func _input(event):
	if event.is_action_pressed("mouse") or event is InputEventScreenTouch:
		PantallaFade.change_scene("res://producto/scenes/Creditos.tscn")

func _on_Timer_timeout():
	PantallaFade.change_scene("res://producto/scenes/Creditos.tscn")
