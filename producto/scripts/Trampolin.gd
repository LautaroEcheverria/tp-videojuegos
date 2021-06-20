extends Node2D

#Variables de movimiento
export var idle_duration = 2.0
export var cell_size = Vector2(24,24)

var medio = Vector2(0,0.25) * cell_size
var move_a = Vector2(0,0.5)
var velocidad  = 24.0

#"Propiedad" de seguimiento
var follow = Vector2.ZERO

#Guarda la posicion de la trampolin y del nodo Tween
onready var trampolin = $TrampolinBody
onready var tween = $Tween
var state

enum State {
	Idle_down,
	Idle_up,
	Move_down,
	Move_up
}
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
	#seguimiento de posicion
	trampolin.position = trampolin.position.linear_interpolate(follow, 0.075)
	#animacion
	var cero = Vector2(0,0)
	if (follow == cero):
		print("alto")
		if $TrampolinBody/SpriteTrampolin.animation != "Idle_up":
			$TrampolinBody/SpriteTrampolin.play("Idle_up")
	elif (follow == move_a):
		print("bajo")
		if $TrampolinBody/SpriteTrampolin.animation != "Idle_down":
			$TrampolinBody/SpriteTrampolin.play("Idle_down")
	elif (follow == medio):
		print("medio")
		if $TrampolinBody/SpriteTrampolin.animation != "Move":
			$TrampolinBody/SpriteTrampolin.play("Move")
		
