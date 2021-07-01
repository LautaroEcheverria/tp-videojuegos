extends Node2D

func _ready():
	$Timer.start()

func _input(event):
	if event.is_action_pressed("mouse") or event is InputEventScreenTouch:
		PantallaFade.change_scene("res://producto/scenes/Plataformas/NivelPlataforma.tscn")

func _on_Timer_timeout():
	PantallaFade.change_scene("res://producto/scenes/Plataformas/NivelPlataforma.tscn")
