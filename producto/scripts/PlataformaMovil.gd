extends KinematicBody2D

var original_position_x
var original_position_y
var velocity = Vector2()
var direccion
var move_speed = 100

var activo = false
var myState = State.IDLE
enum State{
	MOVE,
	IDLE
}

func _ready():
	original_position_x = $CollisionPlataforma/SpritePlataforma.position.x
	direccion = 1

func _physics_process(delta):
	if myState == State.IDLE:
		_in_state_idle_process()
	elif myState == State.MOVE:
		_in_state_move_process(delta)

func _in_state_idle_process():
	""" Buscar srite, modificar la animación
	if $CollisionPlataforma/SpritePlataforma != "idle":
		$CollisionPlataforma/SpritePlataforma.play("idle")
	"""
	if activo == true:
		myState = State.MOVE

func _in_state_move_process(delta):
	""" Buscar srite, modificar la animación
	if $CollisionPlataforma/SpritePlataforma != "move":
		$CollisionPlataforma/SpritePlataforma.play("move")
	"""
	if activo == true:
		if original_position_x + 20 >= $CollisionPlataforma/SpritePlataforma.position.x && direccion ==1:
			velocity.x =  move_speed
		else:
			direccion == -1
		if original_position_x - 20 < $CollisionPlataforma/SpritePlataforma.position.x && direccion ==-1: 
			velocity.x =  -move_speed
		else:
			direccion == 1
	else:
		myState = State.IDLE
	move_and_slide(velocity, Vector2(0, 0))

func _change_activo_value(valor):
	activo = valor

func _on_Button_button_down():
	_change_activo_value(true)

func _on_Button_button_up():
	_change_activo_value(false)
