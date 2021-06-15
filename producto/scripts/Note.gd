extends Node2D

const TARGET_Y = 550
const SPAWN_Y = -50
const DIST_TO_TARGET = TARGET_Y - SPAWN_Y

const LEFT_LANE_SPAWN = Vector2(440, SPAWN_Y)
const CENTRE_LANE_SPAWN = Vector2(640, SPAWN_Y)
const RIGHT_LANE_SPAWN = Vector2(840, SPAWN_Y)

const SPEED_LEVEL_1 = 25
const SPEED_LEVEL_2 = 50
const SPEED_LEVEL_3 = 75

var speed = SPEED_LEVEL_2
var hit = false
var score = 0

func _ready():
	pass
			
func _physics_process(delta):
	if !hit:
		position.y += speed * delta
		if position.y > 720:
			queue_free()
	else:
		$Node2D.position.y -= speed * delta

func initialize(lane,speed_level):
	if lane == 1:
		position = LEFT_LANE_SPAWN
	elif lane == 2:
		position = CENTRE_LANE_SPAWN
	elif lane == 3:
		position = RIGHT_LANE_SPAWN
	if speed_level == 1:
		speed == SPEED_LEVEL_1
	elif speed_level == 2:
		speed == SPEED_LEVEL_2
	elif speed_level == 3:
		speed == SPEED_LEVEL_3

func _on_TouchScreenButton_pressed():
	if position.y >= 536 and position.y <= 656 and score == 0:
		if position.y < 560 or (position.y > 632 and position.y <= 656):
			print("OK")
			score = 1
		elif (position.y >= 560 and position.y < 584) or (position.y > 608 and position.y <= 632):
			print("GOOD")
			score = 2
			$CPUParticles2D.amount = 150
			$CPUParticles2D.initial_velocity = 40
		elif position.y >= 584 and position.y <= 608:
			print("PERFECT")
			score = 3
			$CPUParticles2D.amount = 200
			$CPUParticles2D.initial_velocity = 50
		$CPUParticles2D.emitting = true
		get_parent().set_score(score)
		
