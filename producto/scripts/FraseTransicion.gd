extends Control

var transicion

func _ready():
	$Timer.start()
	transicion = GameHandler.get_transicion()
	if transicion == "/Ritmo/NivelRitmico.tscn":
		set_frase()
		$CanvasLayer/nombre.visible = false

func _input(event):
	if event.is_action("mouse"):
		PantallaFade.change_scene("res://producto/scenes"+str(transicion))	

func _on_Timer_timeout():
	PantallaFade.change_scene("res://producto/scenes"+str(transicion))	
	
func set_frase():
	#var nivel = 4
	var nivel = GameHandler.get_nivel_ritmico()
	$Timer.wait_time = 10
	$Timer.start()
	if nivel == 1:
		$CanvasLayer/frase.text = "Fue compuesta durante su estancia en Estados Unidos y llamó\nla atención de Marco Bellocchio. El director de cine decidió\nincluirla entonces en la banda sonora de la película\n«Enrico IV», estrenada el mismo año en que se publicó el\ndisco. Por esta adaptación el bandoneonista fue nominado a\nlos premios Grammy Awards en 1992, en la categoría de Mejor\nComposición Instrumental. Nunca se enteró, pues falleció\neste mismo año de un infarto cerebral sufrido dos años antes."
	elif nivel == 2:
		$CanvasLayer/frase.text = "Es el título de un tango compuesto por Piazzolla en los\naños 70, antes de la sombría dictadura, pero cuando la\nviolencia social ya se hacía sentir en las calles de\nBuenos Aires. Escuchamos por primera vez Violentango en\nuna sala de un subsuelo porteño, y luego en el magnífico\ndisco Reunión cumbre , donde Astor (bandoneón) compartía\ncon Gerry Mulligan (saxo barítono) la interpretación de\nsus tangos transgresores."
	elif nivel == 3:
		$CanvasLayer/frase.text = "Fue publicado por primera vez en 1974 en Milán. Él la\nconcibió con una obra instrumental, pero se hizo mundialmente\nconocida a través de la versión cantada que grabó con nada\nmenos que Grace Jones en inglés. El director Román Polanski\ntambién la utilizó como banda de sonido de su película\n«Frenético», estrenada en 1988."
	elif nivel == 4:
		$CanvasLayer/frase.text = "Un álbum que estuvo marcado por la muerte de su padre, cuya\nnoticia le llegó cuando se encontraba de gira por Centroamérica.\nEl título del disco y la canción hace referencia al apodo de este,\n«Nonino», que en realidad se llamaba Vicente Piazzolla. La compuso\nen Nueva York, de vuelta de aquel periplo, en un momento de profunda\ntristeza y de angustias económicas, las mismas que le acompañaron\ndurante toda su vida. Fue el tema con el que comenzó su famoso\nconcierto del Teatro Colón en 1983, con el que definió su estilo."
