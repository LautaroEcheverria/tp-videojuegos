extends Area2D

const TARGET_Y = 550
const SPAWN_Y = -50
const DIST_TO_TARGET = TARGET_Y - SPAWN_Y

const LEFT_LANE_SPAWN = Vector2(212, SPAWN_Y)
const CENTRE_LANE_SPAWN = Vector2(512, SPAWN_Y)
const RIGHT_LANE_SPAWN = Vector2(812, SPAWN_Y)

var speed = 100
var hit = false

func _ready():
	pass

func _physics_process(delta):
	if !hit:
		position.y += speed * delta
		if position.y > 700:
			queue_free()
			get_parent().reset_combo()
	else:
		$Node2D.position.y -= speed * delta

func initialize(lane):
	if lane == 1:
		position = LEFT_LANE_SPAWN
	elif lane == 2:
		position = CENTRE_LANE_SPAWN
	elif lane == 3:
		position = RIGHT_LANE_SPAWN

func destroy(score):
	$Sprite.visible = false
	$Timer.start()
	hit = true

func _on_Timer_timeout():
	queue_free()
