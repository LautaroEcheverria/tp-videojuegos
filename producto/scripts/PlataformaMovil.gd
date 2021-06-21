extends Node2D

#Variables de movimiento
export var idle_duration = 2.0
export var move_a = Vector2(24,0)
export var cell_size = Vector2(24,24)
export var velocidad  = 64.0
export var ascensor = true

export var activo = false
#"Propiedad" de seguimiento
var follow = Vector2.ZERO
var previous_follow = Vector2.ZERO
#Guarda la posicion de la plataforma y del nodo Tween
onready var plataforma = $Plataforma
onready var tween = $Tween

func _ready():
	_iniciar_tween()

func _iniciar_tween():
	move_a = move_a * cell_size
	var duracion = move_a.length()/velocidad
	#IDA
	tween.interpolate_property(self, "follow", Vector2.ZERO, 
								   move_a, duracion, Tween.TRANS_LINEAR,
								   Tween.EASE_IN_OUT, idle_duration)
	
	#VUELTA
	tween.interpolate_property(self, "follow", move_a, Vector2.ZERO, 
								   duracion, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 
								   duracion + idle_duration * 2)
	
	tween.start()
	
func _physics_process(delta):
	
	if activo:
		if (tween.pause_mode):
			tween.start()
		#para el flip
		if ascensor == true:
			previous_follow.y = plataforma.position.y
		else:
			previous_follow.x = plataforma.position.x

		#seguimiento de posicion
		plataforma.position = plataforma.position.linear_interpolate(follow, 0.075)
		
		#para el flip
		if ascensor == true:
			previous_follow.x = plataforma.position.x
		else:
			previous_follow.y = plataforma.position.y
		
		#flipeo
		if previous_follow > follow:
			$Plataforma/SpritePlataforma.flip_h = false
		else:
			$Plataforma/SpritePlataforma.flip_h = true
			
		#animacion
		if (follow == Vector2.ZERO) or (follow == move_a):
			$Plataforma/SpritePlataforma.play("Idle")
		else:
			$Plataforma/SpritePlataforma.play("Move")
	else:
		if $Plataforma/SpritePlataforma.animation != "Idle":
			$Plataforma/SpritePlataforma.play("Idle")
		tween.stop(plataforma,"")
