extends KinematicBody2D

var distance = Vector2()
var velocity = Vector2()
var direction_x = 0

export var speed = 150
export var jump_speed = 50
export var gravity = 50

func _ready():
	set_physics_process(true)

func _physics_process(delta):
	_move(delta)

func _move(delta):
	
	direction_x = int(Input.is_action_pressed("ui_right"))-int(Input.is_action_pressed("ui_left"))
	
	distance.x = speed*delta
	velocity.x = (direction_x*distance.x)/delta
	#velocity.y += gravity*delta
	
	move_and_slide(velocity,Vector2(0,-1))
	
	"""
	if is_on_floor():
		
		velocity.y = 0
		
		if Input.is_action_pressed("ui_up"):
			velocity.y = -jump_speed
	"""
