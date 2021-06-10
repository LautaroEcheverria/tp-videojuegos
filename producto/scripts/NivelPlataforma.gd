extends KinematicBody2D

enum State {
	IDLE,
	WALK,
	RUN,
	JUMP,
	FLY1, # WALK -> JUMP -> FLY
	FLY2, # RUN -> JUMP -> FLY
	COLLECT,
	PULL
}

const GRAVITY = 800
const WALK_SPEED = 450
const JUMP_SPEED = -550

var mystate = State.IDLE
var velocity = Vector2()

var touch_left = false # walk
var touch_left2 = false # run
var touch_right = false # walk
var touch_right2 = false # run
var touch_up = false # jump

# DISCOS
var contadorDiscos = 0
var changedScene = false

func _ready():
	
	# Posicion ventana reproduccion
	var screen_size = OS.get_screen_size(OS.get_current_screen())
	var window_size = OS.get_window_size()
	var centered_pos = (screen_size - window_size) / 2
	OS.set_window_position(centered_pos)

func _physics_process(delta):
	
	# Estados Robot
	if mystate == State.IDLE:
		_in_state_idle_process()
	elif mystate == State.WALK:
		_in_state_walk_process(delta)
	elif mystate == State.RUN:
		_in_state_run_process(delta)
	elif mystate == State.JUMP:
		if contadorDiscos >= 1:
			_in_state_jump_process(delta)
		else:
			_in_state_idle_process()
	elif mystate == State.FLY1:
		if contadorDiscos >= 1:
			_in_state_fly_process(delta)
		else:
			_in_state_idle_process()
	elif mystate == State.FLY2:
		if contadorDiscos >= 1:
			_in_state_fly2_process(delta)
		else:
			_in_state_idle_process()
	
	# Guardar y cargar partida		
	if Input.is_action_just_pressed("save"):
		GameHandler.save_game()
		print("Partida guardada")
	elif Input.is_action_just_pressed("load"):
		GameHandler.load_game()
		print("Partida cargada")
		
	# Juego ritmico
	if contadorDiscos == 1 and !changedScene:
		PantallaFade.change_scene("res://producto/scenes/PantallaTransicion.tscn")
		changedScene = true
		
func _in_state_idle_process():
	if $CollisionSprite/Sprite.animation != "idle":
		$CollisionSprite/Sprite.play("idle")
	if Input.is_action_just_pressed("ui_left") or Input.is_action_just_pressed("ui_right") or touch_left or touch_right:
		mystate = State.WALK
	elif Input.is_action_pressed("ui_accept") or touch_left2 or touch_right2:
			mystate = State.RUN
	elif Input.is_action_just_pressed("ui_up") or touch_up:
		mystate = State.JUMP
		
func _in_state_walk_process(delta):
	if $CollisionSprite/Sprite.animation !="walk":
		$CollisionSprite/Sprite.play("walk")
	if is_on_floor():
		velocity.x = 0
		if Input.is_action_pressed("ui_right") or touch_right:
			velocity.x =  WALK_SPEED
			$CollisionSprite/Sprite.flip_h = false
		elif Input.is_action_pressed("ui_left")  or touch_left:
			velocity.x = -WALK_SPEED
			$CollisionSprite/Sprite.flip_h = true
		if Input.is_action_pressed("ui_accept") or touch_left2 or touch_right2:
			mystate = State.RUN
		if Input.is_action_just_pressed("ui_up") or touch_up:
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
		if Input.is_action_pressed("ui_right") or touch_right2:
			velocity.x =  WALK_SPEED*2
			$CollisionSprite/Sprite.flip_h = false
		elif Input.is_action_pressed("ui_left") or touch_left2:
			velocity.x = -WALK_SPEED*2
			$CollisionSprite/Sprite.flip_h = true
		if Input.is_action_just_pressed("ui_up") or touch_up:
			mystate = State.JUMP
		if velocity.x == 0 or not (Input.is_action_pressed("ui_accept") or touch_left2 or touch_right2):
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
		if Input.is_action_pressed("ui_up") or touch_up:
			velocity.y = JUMP_SPEED
		elif Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right") or touch_left or touch_right:
			mystate = State.WALK
		if velocity.x == 0 and not (Input.is_action_pressed("ui_up") or touch_up):
			mystate = State.IDLE
			return
	else:
		velocity.y += delta * GRAVITY
		if (Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right") or touch_left or touch_right) and not (Input.is_action_pressed("ui_accept") or touch_left2 or touch_right2):
			mystate = State.FLY1
		elif (Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right") or touch_left or touch_right) and (Input.is_action_pressed("ui_accept") or touch_left2 or touch_right2):
			mystate = State.FLY2
	move_and_slide(velocity, Vector2(0, -1))

func _in_state_fly_process(delta):
	if is_on_floor():
		velocity.x = 0
		mystate = State.IDLE
	else:
		velocity.y += delta * GRAVITY
		if Input.is_action_pressed("ui_right") or touch_right:
			velocity.x =  WALK_SPEED
			$CollisionSprite/Sprite.flip_h = false
		elif Input.is_action_pressed("ui_left") or touch_left:
			velocity.x = -WALK_SPEED
			$CollisionSprite/Sprite.flip_h = true
	move_and_slide(velocity, Vector2(0, -1))

func _in_state_fly2_process(delta):
	if is_on_floor():
		velocity.x = 0
		mystate = State.IDLE
	else:
		velocity.y += delta * GRAVITY
		if Input.is_action_pressed("ui_right") or touch_right:
			velocity.x =  WALK_SPEED*2
			$CollisionSprite/Sprite.flip_h = false
		elif Input.is_action_pressed("ui_left") or touch_left:
			velocity.x = -WALK_SPEED*2
			$CollisionSprite/Sprite.flip_h = true
	move_and_slide(velocity, Vector2(0, -1))

func _on_LeftButton_pressed():
	touch_left = true
	
func _on_LeftButton_released():
	touch_left = false
	
func _on_LeftButton2_pressed():
	touch_left2 = true

func _on_LeftButton2_released():
	touch_left2 = false

func _on_RightButton_pressed():
	touch_right = true

func _on_RightButton_released():
	touch_right = false

func _on_RightButton2_pressed():
	touch_right2 = true

func _on_RightButton2_released():
	touch_right2 = false

func _on_UpButton_pressed():
	touch_up = true

func _on_UpButton_released():
	touch_up = false

func save():
	var save_dict = {
		"filename" : get_owner().get_filename(),
		"parent" : get_parent().get_path(),
	}
	return save_dict
