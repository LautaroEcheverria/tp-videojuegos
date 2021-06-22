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
var JUMP_SPEED = -450

var mystate = State.IDLE
var velocity = Vector2()

# BOTONES
var touch_left = false # walk
var touch_right = false # walk
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
	cambiarEstado()
	if contadorDiscos >= 1:
		GameHandler.load_game()
		#position.x = GameHandler.player_data.pos_x
		#position.y = GameHandler.player_data.pos_y
		print("Partida cargada")

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
	
	# Guardar partida con checkpoints segun disco
	if GameHandler.saveGame == false and contadorDiscos >= 1: 
		GameHandler.save_game()
		GameHandler.saveGame = true
		print("Partida guardada")
	
func _in_state_idle_process():
	if $CollisionSprite/Sprite.animation != "idle":
		$CollisionSprite/Sprite.play("idle")
	if Input.is_action_just_pressed("ui_left") or Input.is_action_just_pressed("ui_right") or touch_left or touch_right:
		mystate = State.WALK
	elif ((Input.is_action_just_pressed("ui_up") or touch_up) and (contadorDiscos>=1)):
		mystate = State.JUMP
	
	if is_on_floor():
		var snap = 24
		if velocity.y != 0:
			snap = Vector2(0,0)
		move_and_slide_with_snap(velocity,Vector2.DOWN * snap,Vector2(0, -1),false)
	
		
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
		if ((Input.is_action_just_pressed("ui_up") or touch_up) and (contadorDiscos>=1)):
			mystate = State.JUMP
		if velocity.x == 0:
			mystate = State.IDLE
			return
	else:
		velocity.y += delta * GRAVITY
		$CollisionSprite/Sprite.play("jump",true)
	move_and_slide(velocity,Vector2(0,-1))
	
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
	
	var snap = 12
	if velocity.y != 0:
		snap = Vector2(0,0)
	move_and_slide_with_snap(velocity,Vector2.DOWN * snap,Vector2(0, -1),false)
	move_and_slide(velocity,Vector2(0,-1))

func _in_state_fly_process(delta):
	if $CollisionSprite/Sprite.animation !="jump":
		$CollisionSprite/Sprite.play("jump")
	if is_on_floor():
		velocity.x = 0
		mystate = State.IDLE
	else:
		velocity.y += delta * GRAVITY
		if Input.is_action_pressed("ui_right") or touch_right:
			velocity.x =  WALK_SPEED * 0.75
			$CollisionSprite/Sprite.flip_h = false
		elif Input.is_action_pressed("ui_left") or touch_left:
			velocity.x = -WALK_SPEED * 0.75
			$CollisionSprite/Sprite.flip_h = true
	
	var snap = 12
	if velocity.y != 0:
		snap = Vector2(0,0)
	move_and_slide_with_snap(velocity,Vector2.DOWN * snap,Vector2(0, -1),false)
	move_and_slide(velocity,Vector2(0,-1))

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
		get_parent().get_node("Parallax fondo/fondo ciudad/z-2").texture = load("res://producto/assets/img/Plataformas/fondo/2_cielo.jpg")
		get_parent().get_node("Parallax fondo/fondo montañas/z-1").texture = load("res://producto/assets/img/Plataformas/fondo/2_mont.png")
		$Camara/filtro/ColorRect.color = Color("145865ad")
	if contadorDiscos >= 2: #activo colores rojos
		print("rojo")
		get_parent().get_node("Rojo").material.set_shader_param ("byn",1)
		get_parent().get_node("Parallax fondo/fondo ciudad/z-2").texture = load("res://producto/assets/img/Plataformas/fondo/3_cielo.jpg")
		get_parent().get_node("Parallax fondo/fondo montañas/z-1").texture = load("res://producto/assets/img/Plataformas/fondo/3_mont.png")
		$Camara/filtro/ColorRect.color = Color("14ad5858")
	if contadorDiscos >= 3: #activo colores verdes
		print("verde")
		get_parent().get_node("Verde/arbustos").material.set_shader_param ("byn",1)
		get_parent().get_node("Verde/plataformas").visible = true
		get_parent().get_node("Verde/plataformas").material.set_shader_param ("byn",1)
		get_parent().get_node("Parallax fondo/fondo ciudad/z-2").texture = load("res://producto/assets/img/Plataformas/fondo/4_cielo.jpg")
		get_parent().get_node("Parallax fondo/fondo montañas/z-1").texture = load("res://producto/assets/img/Plataformas/fondo/4_mont.png")
		$Camara/filtro/ColorRect.color = Color("1458ad83")
	if contadorDiscos >= 4: #full color
		print("full color")	
		get_parent().get_node("Parallax fondo/fondo ciudad/z-2").texture = load("res://producto/assets/img/Plataformas/fondo/4_cielo.jpg")
		get_parent().get_node("Parallax fondo/fondo montañas/z-1").texture = load("res://producto/assets/img/Plataformas/fondo/4_mont.png")
		$Camara/filtro/ColorRect.color = Color("00ffffff")

func _on_Trampolines_body_entered(body):
	if contadorDiscos >= 3:
		JUMP_SPEED = -450 * 1.5
	else :
		JUMP_SPEED = -450

func _on_Trampolines_body_exited(body):
	JUMP_SPEED = -450

