extends KinematicBody2D

var motion = Vector2()

export var speed = 180
export var jump_speed = -180
export var gravity = 50

func _ready():
	set_physics_process(true)
	
	# Posicion ventana reproduccion
	var screen_size = OS.get_screen_size(OS.get_current_screen())
	var window_size = OS.get_window_size()
	var centered_pos = (screen_size - window_size) / 2
	OS.set_window_position(centered_pos)

func _physics_process(delta):
	_move(delta)

func _move(delta):
	
	motion = Vector2(0,0)
	$CollisionSprite/Sprite.flip_h = false
	$CollisionSprite/Sprite.play("walk")
	
	# Movimientos caminar
	if Input.is_action_pressed("ui_right"):
		motion.x += speed
	if Input.is_action_pressed("ui_left"):
		motion.x -= speed
		$CollisionSprite/Sprite.flip_h = true
	if Input.is_action_pressed("ui_up"):
		motion.y = jump_speed
	if Input.is_action_pressed("ui_down"):
		motion.y -= jump_speed
	
	# Movimientos correr
	if Input.is_action_pressed("ui_right") && Input.is_action_pressed("ui_space"):
		speed = 230
		motion.x += speed
		$CollisionSprite/Sprite.play("run")
	if Input.is_action_pressed("ui_left") && Input.is_action_pressed("ui_space"):
		speed = 230
		motion.x -= speed
		$CollisionSprite/Sprite.flip_h = true
	
	move_and_slide(motion,Vector2(0,-1))
	
	# Poner animacion quieta
	if (motion.x == 0 && motion.y == 0):
		$CollisionSprite/Sprite.play("idle")	
		
