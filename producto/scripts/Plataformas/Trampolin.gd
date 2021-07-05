extends Node2D

#Variables de movimiento
var idle_duration = 0
export var cell_size = Vector2(48,48)

var move_a = Vector2(0,2)
var velocidad  = 90

#"Propiedad" de seguimiento
var follow = Vector2.ZERO
var previo_follow

#Guarda la posicion de la trampolin y del nodo Tween
onready var trampolin = $TrampolinBody/ColisionTrampolin
onready var tween = $Tween
var state
var first_time
enum State {
	Idle_down,
	Idle_up,
	Move_down,
	Move_up
}
func _ready():
	first_time = true

func _iniciar_tween():
	move_a = move_a * cell_size
	var duracion = move_a.length()/velocidad
	#IDA
	tween.interpolate_property(self, "follow", Vector2.ZERO, 
								move_a, duracion, Tween.TRANS_LINEAR,
								Tween.EASE_IN_OUT, idle_duration)
	tween.start()
	
func _physics_process(delta):
	if first_time:
		_iniciar_tween()
		first_time = false
	
	
	#seguimiento de posicion
	previo_follow = follow
	trampolin.position = trampolin.position.linear_interpolate(follow, 0.075)
	
	#animacion
	if (state == State.Idle_up):
		if $TrampolinBody/SpriteTrampolin.animation != "Idle_up":
			$TrampolinBody/SpriteTrampolin.play("Idle_up")
	if (state == State.Idle_down):
		if $TrampolinBody/SpriteTrampolin.animation != "Idle_down":
			$TrampolinBody/SpriteTrampolin.play("Idle_down")
	if (state == State.Move_down):
		if $TrampolinBody/SpriteTrampolin.animation != "Move_down":
			$TrampolinBody/SpriteTrampolin.play("Move_down")
		if ($TrampolinBody/SpriteTrampolin.frame == 2):
			tween.stop_all()
			state = State.Idle_down
	if (state == State.Move_up):
		if $TrampolinBody/SpriteTrampolin.animation != "Move_up":
			$TrampolinBody/SpriteTrampolin.play("Move_up")
		if ($TrampolinBody/SpriteTrampolin.frame == 2):
			tween.stop_all()
			state = State.Idle_up

func _down():
	tween.seek(0)
	tween.resume_all()
	state = State.Move_down
	

func _up():
	tween.seek(0)
	state = State.Move_up
	
