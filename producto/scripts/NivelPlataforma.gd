extends KinematicBody2D

enum State {
	IDLE,
	WALK,
	JUMP,
	FLY, 
	COLLECT,
	PULL
}

const GRAVITY = 800
var WALK_SPEED = 150
var JUMP_SPEED = -600

var mystate = State.IDLE
var velocity = Vector2()

# BOTONES
var touch_left = false # walk
var touch_right = false # walk
var touch_up = false # jump

# DISCOS
var contadorDiscos = 0
var changedScene = false

# PERSISTENCIA
var saveGame = false # Arranco en true pero se hizo asi para probar

func _ready():
	
	# Posicion ventana reproduccion
	var screen_size = OS.get_screen_size(OS.get_current_screen())
	var window_size = OS.get_window_size()
	var centered_pos = (screen_size - window_size) / 2
	OS.set_window_position(centered_pos)
	GameHandler.load_game()
	cambiarEstado()

func _physics_process(delta):
	
	# Estados Robot
	if mystate == State.IDLE:
		_in_state_idle_process()
	elif mystate == State.WALK:
		_in_state_walk_process(delta)
	elif mystate == State.JUMP:
		if contadorDiscos >= 1:
			_in_state_jump_process(delta)
		else:
			_in_state_idle_process()
	elif mystate == State.FLY:
		if contadorDiscos >= 1:
			_in_state_fly_process(delta)
		else:
			_in_state_idle_process()
	
	# Movimientos desbloqueados
	if contadorDiscos >= 1:
		WALK_SPEED = 300
	
	# Guardar y cargar partida con checkpoints
	if saveGame == false and contadorDiscos >= 1: # solo va saveGame ya que lo otro se cambia por funcion new_checkpoint() cuando encuentra disco nuevo
		GameHandler.save_game()
		saveGame = true
		print("Partida guardada")
	
func _in_state_idle_process():
	if $CollisionSprite/Sprite.animation != "idle":
		$CollisionSprite/Sprite.play("idle")
	if Input.is_action_just_pressed("ui_left") or Input.is_action_just_pressed("ui_right") or touch_left or touch_right:
		mystate = State.WALK
	elif Input.is_action_just_pressed("ui_up") or touch_up:
		mystate = State.JUMP
		
func _in_state_walk_process(delta):
	if contadorDiscos < 1 :
		if $CollisionSprite/Sprite.animation !="walk":
			$CollisionSprite/Sprite.play("walk")
	else:
		if $CollisionSprite/Sprite.animation !="run":
			$CollisionSprite/Sprite.play("run")
	if is_on_floor():
		velocity.x = 0
		if Input.is_action_pressed("ui_right") or touch_right:
			velocity.x =  WALK_SPEED
			$CollisionSprite/Sprite.flip_h = false
		elif Input.is_action_pressed("ui_left")  or touch_left:
			velocity.x = -WALK_SPEED
			$CollisionSprite/Sprite.flip_h = true
		if Input.is_action_just_pressed("ui_up") or touch_up:
			mystate = State.JUMP
		if velocity.x == 0:
			mystate = State.IDLE
			return
	else:
		velocity.y += delta * GRAVITY
	move_and_slide(velocity, Vector2(0, -1))
	
func _in_state_jump_process(delta):
	if $CollisionSprite/Sprite.animation !="jump":
		$CollisionSprite/Sprite.play("jump")
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
		if (Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right") or touch_left or touch_right) and not (Input.is_action_pressed("ui_accept")):
			mystate = State.FLY
	move_and_slide(velocity, Vector2(0, -1))

func _in_state_fly_process(delta):
	if $CollisionSprite/Sprite.animation !="jump":
		$CollisionSprite/Sprite.play("jump")
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

func _on_LeftButton_pressed():
	touch_left = true
	
func _on_LeftButton_released():
	touch_left = false

func _on_RightButton_pressed():
	touch_right = true

func _on_RightButton_released():
	touch_right = false

func _on_UpButton_pressed():
	touch_up = true

func _on_UpButton_released():
	touch_up = false

func save():
	var save_dict = {
		"filename" : get_owner().get_filename(),
		"parent" : get_parent().get_path(),
		"contadorDiscos" : contadorDiscos
	}
	return save_dict
	
# Funcion para guardar cuando aumente contadorDiscos
func new_checkpoint(): 
	saveGame = false


func cambiarEstado():
	contadorDiscos = GameHandler.getDisco()
	color()
	
# Funcion para cambiar los colores
func color():
	if contadorDiscos >= 1: # activo colores azules
		print("azul")
		get_parent().get_node("Azul").material.set_shader_param ("byn",1)
		get_parent().get_node("Sombra Secretos").material.set_shader_param ("byn",1)
		get_parent().get_node("Parallax frente/frente").material.set_shader_param ("byn",1)
		get_parent().get_node("Parallax camino/camino").material.set_shader_param ("byn",1)
		material.set_shader_param ("byn",1)
	if contadorDiscos >= 2: #activo colores rojos
		print("rojo")
		get_parent().get_node("Rojo").material.set_shader_param ("byn",1)
	if contadorDiscos >= 3: #activo colores verdes
		print("verde")
		get_parent().get_node("Verde/arbustos").material.set_shader_param ("byn",1)
		get_parent().get_node("Verde/plataformas").visible = true
		get_parent().get_node("Verde/plataformas").material.set_shader_param ("byn",1)
	if contadorDiscos >= 4: #full color
		print("full color")	


func _on_Trampolines_body_entered(body):
	if contadorDiscos >= 3
		JUMP_SPEED = -600 * 2
	else 
		JUMP_SPEED = -600

func _on_Trampolines_body_exited(body):
	JUMP_SPEED = -600
