extends KinematicBody2D

var motion = Vector2()

export var speed = 200
export var jump_speed = -550
export var gravity = 50

func _ready():
	set_physics_process(true)

func _physics_process(delta):
	_move(delta)

func _move(delta):
	
	motion = Vector2(0,0)
	$CollisionSprite/Sprite.flip_h = false
	$CollisionSprite/Sprite.play("walk")	
	
	if Input.is_action_pressed("ui_right"):
		motion.x += speed
	if Input.is_action_pressed("ui_left"):
		motion.x -= speed
		$CollisionSprite/Sprite.flip_h = true
	if Input.is_action_pressed("ui_up"):
		motion.y = jump_speed
	if Input.is_action_pressed("ui_down"):
		motion.y -= jump_speed
	
	move_and_slide(motion,Vector2(0,-1))
	
	if (motion.x == 0 && motion.y == 0):
		$CollisionSprite/Sprite.play("idle")	
		
