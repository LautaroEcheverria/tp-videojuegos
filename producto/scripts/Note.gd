extends Node2D

const TARGET_Y = 550
const SPAWN_Y = -50
const DIST_TO_TARGET = TARGET_Y - SPAWN_Y

const LEFT_LANE_SPAWN = Vector2(440, SPAWN_Y)
const CENTRE_LANE_SPAWN = Vector2(640, SPAWN_Y)
const RIGHT_LANE_SPAWN = Vector2(840, SPAWN_Y)

const SPEED_LEVEL_1 = 150
const SPEED_LEVEL_2 = 200
const SPEED_LEVEL_3 = 250

var speed = SPEED_LEVEL_2
var score = 0
var setScore = false

func _ready():
	randomize()
			
func _physics_process(delta):
	position.y += speed * delta
	if position.y > 656 and score == 0 and !setScore:
		setScore = true
		get_parent().set_score(score)
	if position.y > 748:
		queue_free()

func initialize(lane):
	if lane == 1:
		position = LEFT_LANE_SPAWN
	elif lane == 2:
		position = CENTRE_LANE_SPAWN
	elif lane == 3:
		position = RIGHT_LANE_SPAWN

func _on_TouchScreenButton_pressed():
	if position.y >= 536 and position.y <= 656 and score == 0:
		if position.y < 560 or (position.y > 632 and position.y <= 656):
			score = 1
		elif (position.y >= 560 and position.y < 584) or (position.y > 608 and position.y <= 632):
			score = 2
			$CPUParticles2D.amount = 150
			$CPUParticles2D.initial_velocity = 40
		elif position.y >= 584 and position.y <= 608:
			score = 3
			$CPUParticles2D.amount = 200
			$CPUParticles2D.initial_velocity = 50
		$CPUParticles2D.emitting = true
		get_parent()._button_entered(true,position.x)
		get_parent().set_score(score)
			
func set_speed(speed_level):
	if speed_level == 1:
		speed = SPEED_LEVEL_1
	elif speed_level == 2:
		speed = SPEED_LEVEL_2
	elif speed_level == 3:
		speed = SPEED_LEVEL_3

func set_color(value,lane):
	if value == 1:
		$TouchScreenButton.modulate = Color("#ffffff")
	elif value == 2:
		$TouchScreenButton.normal = load("res://producto/assets/img/Ritmo/Note2.png")
		$TouchScreenButton.scale.x = 0.198
		$TouchScreenButton.scale.y = 0.208
		$TouchScreenButton.position.x = -99
		$TouchScreenButton.position.y = -80
	elif value == 3:
		$TouchScreenButton.modulate = Color("#00ff0a")
	elif value == 4:
		if lane == 1:
			$TouchScreenButton.modulate = Color("#ffffff")
		elif lane == 2:
			$TouchScreenButton.normal = load("res://producto/assets/img/Ritmo/Note2.png")
			$TouchScreenButton.scale.x = 0.198
			$TouchScreenButton.scale.y = 0.208
			$TouchScreenButton.position.x = -99
			$TouchScreenButton.position.y = -80
		elif lane == 3:
			$TouchScreenButton.modulate = Color("#00ff0a")
