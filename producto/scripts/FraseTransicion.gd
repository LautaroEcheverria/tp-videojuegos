extends Control

var transicion

func _ready():
	$Timer.start()
	transicion = GameHandler.get_transicion()
	if transicion == "/Ritmo/NivelRitmico.tscn":
		set_frase()
		$CanvasLayer/nombre.visible = false

func _input(event):
	if event.is_action_pressed("mouse") or event is InputEventScreenTouch:
		PantallaFade.change_scene("res://producto/scenes"+str(transicion))	

func _on_Timer_timeout():
	PantallaFade.change_scene("res://producto/scenes"+str(transicion))	
	
func set_frase():
	var nivel = GameHandler.get_nivel_ritmico()
	$Timer.wait_time = 10
	$Timer.start()
	if nivel == 1:
		$CanvasLayer/frase.text = "Fue compuesta durante su estancia en Estados Unidos y\nfue incluida banda sonora de la película «Enrico IV».\nPor esta adaptación Piazzola fue nominado a los premios\nGrammy Awards en 1992. Nunca se enteró, pues falleció\nese mismo año de un infarto cerebral."
	elif nivel == 2:
		$CanvasLayer/frase.text = "«Violentango» es el título de un tango compuesto por\nPiazzolla en los años 70, antes de la sombría dictadura,\ncuando la violencia social ya se hacía sentir en las\ncalles de Buenos Aires. Fue entonces que escuchamos por\nprimera vez esta canción, en una sala de un subsuelo porteño."
	elif nivel == 3:
		$CanvasLayer/frase.text = "Publicado por primera vez en 1974 en Milán, fue un tango\ncreado junto a Violentango. Sin embargo, la creación de\nLibertango evoca un himno a la expansión, amor y creatividad.\nEvoca a la propia libertad. Insuflándonos de otros ideales,\notros sueños y otras realidades posibles."
	elif nivel == 4:
		$CanvasLayer/frase.text = "La noticia de la muerte de su padre, apodado «Nonino», le\nllegó cuando se encontraba de gira por Centroamérica. Compuso\nesta canción en Nueva York, en un momento de profunda tristeza\ny de angustias económicas, las mismas que le acompañaron\ndurante toda su vida. Fue el tema con el que definió su estilo."
