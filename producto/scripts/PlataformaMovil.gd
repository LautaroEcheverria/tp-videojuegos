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
	original_position_x = $ColisionPlataforma.position.x
	direccion = 1

func _physics_process(delta):
	if myState == State.IDLE:
		_in_state_idle_process()
	elif myState == State.MOVE:
		_in_state_move_process(delta)

func _in_state_idle_process():
	if $ColisionPlataforma/SpritePlataforma.animation != "Idle":
		$ColisionPlataforma/SpritePlataforma.play("Idle")
	if activo == true:
		myState = State.MOVE

func _in_state_move_process(delta):
	if activo == true:
		if original_position_x + 200 >= $CollisionPlataforma.position.x && direccion ==1:
			velocity.x =  move_speed
			if $SpritePlataforma.animation != "Move_right":
				$SpritePlataforma.play("Move_right")
		else:
			direccion == -1
		if original_position_x - 200 < $CollisionPlataforma.position.x && direccion ==-1: 
			velocity.x =  -move_speed
			if $SpritePlataforma.animation != "Move_left":
				$SpritePlataforma.play("Move_left")
		else:
			direccion == 1
	else:
		myState = State.IDLE
	move_and_slide(velocity, Vector2(0, -1))

func _on_Button_pressed():	
	activo = !activo
	print("hola")
