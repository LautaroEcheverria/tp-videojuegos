extends Control




# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Timer_timeout():
	PantallaFade.change_scene("res://producto/scenes/NivelPlataforma.tscn")
