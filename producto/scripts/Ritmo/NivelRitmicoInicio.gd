extends Node2D

func _ready():
	pass # Replace with function body.

func _on_BotonFacil_pressed():
	GameHandler.set_speed_nivel_ritmico(1) # speed = 1
	$CanvasLayer/VBoxContainer/BotonFacil.modulate = Color("c3ffffff")
	transicion()

func _on_BotonIntermedio_pressed():
	GameHandler.set_speed_nivel_ritmico(2) # speed = 2
	$CanvasLayer/VBoxContainer/BotonIntermedio.modulate = Color("c3ffffff")
	transicion()

func _on_BotonDificil_pressed():
	GameHandler.set_speed_nivel_ritmico(3) # speed = 3
	$CanvasLayer/VBoxContainer/BotonDificil.modulate = Color("c3ffffff")
	transicion()

func _on_BotonFacil_button_up():
	$CanvasLayer/VBoxContainer/BotonFacil.modulate = Color("ffffff")
	
func _on_BotonIntermedio_button_up():
	$CanvasLayer/VBoxContainer/BotonIntermedio.modulate = Color("ffffff")

func _on_BotonDificil_button_up():
	$CanvasLayer/VBoxContainer/BotonDificil.modulate = Color("ffffff")

func transicion():
	GameHandler.set_transicion("NivelRitmico")
	PantallaFade.change_scene("res://producto/scenes/FraseTransicion.tscn")
