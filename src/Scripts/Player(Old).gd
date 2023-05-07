extends CharacterBody2D

@export var move_speed = 200.0
var dash_speed = move_speed * 2
const dash_duration = 0.2

var moving_on_floor = false
var velocity := Vector2.ZERO
var move_dir = 0.0

@export var jump_height : float
@export var jump_time_to_peak : float
@export var jump_time_to_descent : float

@onready var jump_velocity : float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
@onready var jump_gravity : float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
@onready var fall_gravity : float = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0

@onready var sprite = $AnimatedSprite2D
@onready var dash = $Dash

@onready var AnimTree = $AnimatedSprite2D/AnimationTree

func _ready():
	$AnimatedSprite2D/AnimationTree.active = true

func _physics_process(delta):
	velocity.y += get_gravity() * delta
	velocity.x = move_dir * move_speed * delta
	
	get_input()
	animation()
	debug()
	boolStuff()
	
	if dash.is_dashing():
		if sprite.flip_h == false:
			velocity.x = velocity.x + dash_speed if dash.is_dashing() else move_speed
		else:
			velocity.x = velocity.x - dash_speed if dash.is_dashing() else move_speed
	
	set_velocity(velocity)
	set_up_direction(Vector2.UP)
	move_and_slide()
	velocity = velocity

func get_input():
	
	if Input.is_action_pressed("left"):
		move_dir -= 1.0
	elif Input.is_action_pressed("right"):
		move_dir += 1.0
	else:
		move_dir = 0
	
	if Input.is_action_just_pressed("jump"):
		velocity.y = jump_velocity
	
	if Input.is_action_just_pressed("dash") && !dash.is_dashing() && dash.can_dash:
		dash.start_dash(sprite, dash_duration)

func get_gravity() -> float:
	return jump_gravity if velocity.y < 0.0 else fall_gravity
	
	

func animation():
	
	if Input.is_action_just_pressed("right"):
		sprite.flip_h = false
	elif Input.is_action_just_pressed("left"):
		sprite.flip_h = true
		
	if moving_on_floor == false:
		AnimTree.set("parameters/movement/current", 0) # idle
	if moving_on_floor == true:
		AnimTree.set("parameters/movement/current", 1) # Run
	
	if  Input.is_action_pressed("jump"):
		AnimTree.set("parameters/in_air/current", 1) # Jumping
	elif Input.is_action_just_released("jump"):
		AnimTree.set("parameters/in_air/current", 0) # Falling
		
	AnimTree.set("parameters/movement_time/scale", 1  + abs(velocity.x)/100)
	AnimTree.set("parameters/in_air_state/current", int(!$GroundDetector.is_colliding()))

func boolStuff():
	if Input.is_action_pressed("right") and is_on_floor() or Input.is_action_pressed("left") and is_on_floor():
		moving_on_floor = true
	else:
		moving_on_floor = false

func debug():
	$Label.text = "MoF: " + str(moving_on_floor)
