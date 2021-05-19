extends KinematicBody2D

var velocity = Vector2()

export var WALK_SPEED = 200
export var RUN_SPEED = 300
export var JUMP_SPEED = -400
export var GRAVITY = 800

enum state {
	IDLE,
	WALK,
	RUN,
	JUMP,
}

var myState = state.IDLE

func _ready():
	set_physics_process(true)
	
	# Posicion ventana reproduccion
	var screen_size = OS.get_screen_size(OS.get_current_screen())
	var window_size = OS.get_window_size()
	var centered_pos = (screen_size - window_size) / 2
	OS.set_window_position(centered_pos)

func _physics_process(delta):
	if myState == state.IDLE:
		_in_state_idle_process()
	elif myState == state.WALK:
		_in_state_walk_process(delta)
	elif myState == state.RUN:
		_in_state_run_process(delta)
	elif myState == state.JUMP:
		_in_state_jump_process(delta)

func _in_state_idle_process():
	
	if $CollisionSprite/Sprite.animation != "idle":
		$CollisionSprite/Sprite.play("idle")
	if Input.is_action_just_pressed("ui_right") or Input.is_action_just_pressed("ui_left"):
		myState = state.WALK

func _in_state_walk_process(delta):
	
	if $CollisionSprite/Sprite.animation != "walk":
		$CollisionSprite/Sprite.play("walk")
	if is_on_floor():	
		velocity.x = 0
		# Movimientos caminar
		if Input.is_action_pressed("ui_right"):
			velocity.x = WALK_SPEED
		if Input.is_action_pressed("ui_left"):
			velocity.x -= WALK_SPEED
			$CollisionSprite/Sprite.flip_h = true
		if Input.is_action_pressed("ui_accept") && (Input.is_action_pressed("ui_right") or Input.is_action_pressed("ui_left")):
			myState = state.RUN
		if velocity.x == 0:
			myState = state.IDLE
			return
	else:
		myState = state.JUMP
	move_and_slide(velocity,Vector2(0,-1))

func _in_state_run_process(delta):
	
	if $CollisionSprite/Sprite.animation != "run":
		$CollisionSprite/Sprite.play("run") 
	if is_on_floor():	
		velocity.x = 0
		# Movimientos correr
		if Input.is_action_pressed("ui_accept"):
			if Input.is_action_pressed("ui_right"):
					velocity.x = RUN_SPEED
			if Input.is_action_pressed("ui_left"):
				velocity.x -= RUN_SPEED
				$CollisionSprite/Sprite.flip_h = true
		if velocity.x == 0:
			myState = state.IDLE
		else:
			myState = state.WALK
		return
	else:
		myState = state.JUMP
	move_and_slide(velocity,Vector2(0,-1))

func _in_state_jump_process(delta):
	
	velocity.y = GRAVITY * delta
	move_and_slide(velocity,Vector2(0,-1))
