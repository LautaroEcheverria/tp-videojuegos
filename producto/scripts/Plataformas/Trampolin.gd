extends Node2D

#Variables de movimiento
export var idle_duration = 0
export var cell_size = Vector2(48,48)

var move_a = Vector2(0,1.20)
var velocidad  = 64.0

#"Propiedad" de seguimiento
var follow = Vector2.ZERO
var previo_follow

#Guarda la posicion de la trampolin y del nodo Tween
onready var trampolin = $TrampolinBody/ColisionTrampolin
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
	tween.start()
	
func _physics_process(delta):
	#seguimiento de posicion
	previo_follow = follow
	trampolin.position = trampolin.position.linear_interpolate(follow, 0.075)
	
	#animacion
	if (state == State.Idle_up):
		if $TrampolinBody/SpriteTrampolin.animation != "Idle_up":
			$TrampolinBody/SpriteTrampolin.play("Idle_up")
			tween.stop_all()
	if (state == State.Idle_down):
		if $TrampolinBody/SpriteTrampolin.animation != "Idle_down":
			$TrampolinBody/SpriteTrampolin.play("Idle_down")
			tween.stop_all()
	if (state == State.Move_down):
		if $TrampolinBody/SpriteTrampolin.animation != "Move_down":
			$TrampolinBody/SpriteTrampolin.play("Move_down")
		if ($TrampolinBody/SpriteTrampolin.frame == 4):
			state = State.Idle_down
	if (state == State.Move_up):
		if $TrampolinBody/SpriteTrampolin.animation != "Move_up":
			$TrampolinBody/SpriteTrampolin.play("Move_up")
		if ($TrampolinBody/SpriteTrampolin.frame == 4):
			state = State.Idle_up

func _down():
	state = State.Move_down
	tween.resume_all()

func _up():
	tween.reset_all()
	state = State.Move_up
	
