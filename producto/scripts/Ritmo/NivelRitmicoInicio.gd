extends Node2D

func _ready():
	pass # Replace with function body.

func _on_BotonFacil_pressed():
	GameHandler.set_speed_nivel_ritmico(1) # speed = 1
	$Botones/Control/VBoxContainer/BotonFacil.modulate = Color("#888888")
	transicion()

func _on_BotonIntermedio_pressed():
	GameHandler.set_speed_nivel_ritmico(2) # speed = 2
	$Botones/Control/VBoxContainer/BotonIntermedio.modulate = Color("#888888")
	transicion()

func _on_BotonDificil_pressed():
	GameHandler.set_speed_nivel_ritmico(3) # speed = 3
	$Botones/Control/VBoxContainer/BotonDificil.modulate = Color("#888888")
	transicion()

func _on_BotonFacil_released():
	$Botones/Control/VBoxContainer/BotonFacil.modulate = Color("#ffffff")

func _on_BotonIntermedio_released():
	$Botones/Control/VBoxContainer/BotonIntermedio.modulate = Color("#ffffff")

func _on_BotonDificil_released():
	$Botones/Control/VBoxContainer/BotonDificil.modulate = Color("#ffffff")

func transicion():
	GameHandler.set_transicion("NivelRitmico")
	PantallaFade.change_scene("res://producto/scenes/FraseTransicion.tscn")
