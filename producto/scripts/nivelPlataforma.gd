extends KinematicBody2D

enum State {
	IDLE,
	WALK,
	RUN,
	JUMP,
	COLLECT
}

const GRAVITY = 800
const WALK_SPEED = 350
const JUMP_SPEED = -550

var mystate = State.IDLE
var velocity = Vector2()

func _ready():
	
	# Posicion ventana reproduccion
	var screen_size = OS.get_screen_size(OS.get_current_screen())
	var window_size = OS.get_window_size()
	var centered_pos = (screen_size - window_size) / 2
	OS.set_window_position(centered_pos)


func _physics_process(delta):
	if mystate == State.IDLE:
		_in_state_idle_process()
	elif mystate == State.WALK:
		_in_state_walk_process(delta)
	elif mystate == State.RUN:
		_in_state_run_process(delta)
	elif mystate == State.JUMP:
		_in_state_jump_process(delta)
		
		
func _in_state_idle_process():
	if $CollisionSprite/Sprite.animation != "idle":
		$CollisionSprite/Sprite.play("idle")
	if Input.is_action_just_pressed("ui_left") or Input.is_action_just_pressed("ui_right"):
		mystate = State.WALK
	elif Input.is_action_just_pressed("ui_up"):
		mystate = State.JUMP
		
		
func _in_state_walk_process(delta):
	if $CollisionSprite/Sprite.animation !="walk":
		$CollisionSprite/Sprite.play("walk")
	if is_on_floor():
		velocity.x = 0
		if Input.is_action_pressed("ui_left"):
			velocity.x = -WALK_SPEED
			$CollisionSprite/Sprite.flip_h = true
		elif Input.is_action_pressed("ui_right"):
			velocity.x =  WALK_SPEED
			$CollisionSprite/Sprite.flip_h = false
		if Input.is_action_pressed("ui_accept"):
			mystate = State.RUN
		if Input.is_action_just_pressed("ui_up"):
			mystate = State.JUMP
		if velocity.x == 0:
			mystate = State.IDLE
			return
	else:
		velocity.y += delta * GRAVITY
	move_and_slide(velocity, Vector2(0, -1))
	
	
func _in_state_run_process(delta):
	if $CollisionSprite/Sprite.animation !="run":
		$CollisionSprite/Sprite.play("run")
	if is_on_floor():
		velocity.x = 0
		if Input.is_action_pressed("ui_left"):
			velocity.x = -WALK_SPEED*2
			$CollisionSprite/Sprite.flip_h = true
		elif Input.is_action_pressed("ui_right"):
			velocity.x =  WALK_SPEED*2
			$CollisionSprite/Sprite.flip_h = false
		if Input.is_action_just_pressed("ui_up"):
			mystate = State.JUMP
		if velocity.x == 0 or not Input.is_action_pressed("ui_accept"):
			if velocity.x == 0:
				mystate = State.IDLE
			else:
				mystate = State.WALK
			return
	else:
		velocity.y += delta * GRAVITY
	move_and_slide(velocity, Vector2(0, -1))


func _in_state_jump_process(delta):
	if is_on_floor():
		if Input.is_action_pressed("ui_up"):
			velocity.y = JUMP_SPEED
		if Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right"):
			mystate = State.WALK
		if velocity.x == 0 and not Input.is_action_pressed("ui_up"):
			mystate = State.IDLE
			return
	else:
		 velocity.y += delta * GRAVITY
	move_and_slide(velocity, Vector2(0, -1))
