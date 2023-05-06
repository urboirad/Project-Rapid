extends KinematicBody2D

# Nodes
onready var hitbox = $Hitbox
onready var Anim = $AnimatedSprite
onready var dash = $Dash
onready var wallCast = $WallDetector
onready var floorCast = $floorDetect
onready var slopeCast = $slopeDetect
onready var gR = $groundDetectR
onready var gL = $groundDetectL

# Export Variables
export(int) var JUMP_FORCE = -130
export(int) var JUMP_RELEASE_FORCE = -70
export(int) var MAX_SPEED = 50
export(int) var ACCELERATION = 10
export(int) var FRICTION = 10
export(int) var GRAVITY = 4
export(int) var ADDITIONAL_FALL_GRAVITY = 4

# Physics Variables
var velocity = Vector2.ZERO
var collisionNorm = get_floor_normal()
const UP = Vector2(0, -1)

# Dash Variables
var dash_speed = 0
const dash_duration = 0.2

# Animation Bools / Variables
var dir = 0
var starting_run = true
var reverse_to_right = false
var reverse_to_left = true
var was_in_air = false
var start_fall = false
var start_crouch = false

var charge_jumping = false

func _ready():
	pass
	
func _physics_process(delta):
	
	forwardCamera() # Moves camera forward to compensate for speed
	wallDetector() # Checks if Wall Detector is colliding
	rotateSprite() # rotates sprite depeding on surface
	cameraZoom() # Camera zooms in when in tight spaces
	debugText() # Updates debug text
	apply_gravity() # Applies character's gravity
	
	if !dash.is_dashing(): # If Player isn't Dashing
		animations() # Updates Animations
	
	# Left and Right Input
	var input = Vector2.ZERO
	if !start_crouch:
		input.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	if input.x == 0 or start_crouch:
		apply_friction() # Applies friction to player
	else:
		apply_acceleration(input.x) # Applies acceleration to player
	
	# Jump input
	if is_on_floor():
		if Input.is_action_just_pressed("jump"):
			jump()
	else:
		if Input.is_action_just_released("jump") and velocity.y < JUMP_RELEASE_FORCE:
			velocity.y = JUMP_RELEASE_FORCE
		if velocity.y > 0:
			velocity.y += ADDITIONAL_FALL_GRAVITY
	
	# Dash speed
	dash_speed = (velocity.x + 1800) * delta

	# Dash input
	if Input.is_action_just_pressed("dash") && !dash.is_dashing() && dash.can_dash:
		dash.start_dash(Anim, dash_duration)
	
	# Enable Wall Detector (for wall bounce)
	if velocity.y <= 20 && wallCast.enabled == false:
		wallCast.enabled = true
	
	# If player is dashing...
	if dash.is_dashing():
		Anim.play("Dash")
		if wallCast.is_colliding():
			if Anim.flip_h == false:
				dash.end_dash()
				Anim.flip_h = true
				wallCast.enabled = false
				wallJump()
			else:
				dash.end_dash()
				Anim.flip_h = false
				wallCast.enabled = false
				wallJump()
				
		if Anim.flip_h == false:
			velocity.x = velocity.x + dash_speed if dash.is_dashing() else MAX_SPEED
		else:
			velocity.x = velocity.x - dash_speed if dash.is_dashing() else MAX_SPEED
	
	# Player snap and no snap control
	var snap = Vector2.DOWN * 128 if is_on_floor() else Vector2.ZERO
	if get_floor_normal().angle() < -0.7 && !Input.is_action_just_pressed("jump") && floorCast.is_colliding() && slopeCast.is_colliding():
		velocity = move_and_slide_with_snap(velocity, snap, UP, true)
	else:
		velocity = move_and_slide(velocity, UP, true)
		
	if charge_jumping:
		pass
			
func jump(): # Jump function dummy
	velocity.y = JUMP_FORCE

func wallJump(): # Wall bounce function
	if Anim.flip_h == false:
		velocity.y = JUMP_FORCE # Make player jump
		velocity.x = velocity.x + dash_speed # Make player bounce off
	elif Anim.flip_h == true:
		velocity.y = JUMP_FORCE # Make player jump
		velocity.x = velocity.x - dash_speed # Make player bounce off

func animations(): # Animation update
	if Input.is_action_just_pressed("right"):
		Anim.flip_h = false
	elif Input.is_action_just_pressed("left"):
		Anim.flip_h = true
	# Right...
	if Input.is_action_pressed("right") && !Input.is_action_pressed("left"):
		# Activate Skid Animation
		reverse_to_left = true
		
		if is_on_floor():
			# Walk Animation
			if reverse_to_right == false && velocity.x < 200: # If speed is less than run speed...
				if !start_crouch:
					Anim.play("Walk")
			# Skid Animation
			elif reverse_to_right == true && velocity.x < -60: # If skidding...
				if !start_crouch:
					Anim.play("Skid")
			else: # If run speed...
				if !start_crouch:
					Anim.play("Run")
	# Left
	if Input.is_action_pressed("left") && !Input.is_action_pressed("right"):
		# Activate Skid Animation
		reverse_to_right = true
		
		if is_on_floor():
			# Walk Animation
			if reverse_to_left == false && velocity.x > -200: # If speed is less than run speed...
				if !start_crouch:
					Anim.play("Walk")
			# Skid Animation
			elif reverse_to_left == true && velocity.x > 60: # If skidding...
				if !start_crouch:
					Anim.play("Skid")
			else: # If run speed...
				if !start_crouch:
					Anim.play("Run")

	# Deactivate Skid Animation
	if Input.is_action_just_released("right"):
		reverse_to_right = false
	if Input.is_action_just_released("left"):
		reverse_to_left = false
	
	if is_on_floor():
		
		# Fall Transition Animation
		if start_fall == false:
			start_fall = true
			
		# Crouch Transition Animation
		#if start_crouch == false:
			#start_crouch = true
			
		# Idle Animation
		if velocity.x == 0 && !start_crouch: 
			Anim.play("Idle")
			
		# Run Aniamtion
		if Input.is_action_just_released("right") or Input.is_action_just_released("left"):
			starting_run = true
		
		# Crouch Animation
		if Input.is_action_pressed("down"):
			start_crouch = true
		elif Input.is_action_just_released("down"):
			start_crouch = false
			
		if start_crouch == true:
			Anim.play("Crouch")
			
	else:
		# Jump Animation
		if velocity.y < 0:
			Anim.play("Jump")
			
		# Fall Animation
		elif velocity.y > 0:
			if start_fall == true:
				Anim.play("toFall")
			elif start_fall == false:
				Anim.play("Fall") # Falling
				
	# Match Anim Speed
	if velocity.x >= 300 or velocity.x <= -300:
		Anim.speed_scale = lerp(Anim.speed_scale, 2, 0.01)
	else:
		Anim.speed_scale = 1

# Physics stuff...
func apply_gravity():
	velocity.y += GRAVITY
	velocity.y = min(velocity.y, 300)
func apply_friction():
	velocity.x = move_toward(velocity.x, 0, FRICTION)
func apply_acceleration(amount):
	velocity.x = move_toward(velocity.x, MAX_SPEED * amount, ACCELERATION)

# Camera
func forwardCamera():
	if velocity.x >= MAX_SPEED && Anim.flip_h == false:
		$Camera2D.offset_h = move_toward(0, 0.6, 1)
	elif velocity.x <= -MAX_SPEED && Anim.flip_h == true:
		$Camera2D.offset_h = move_toward(0, -0.6, 1)
	else:
		$Camera2D.offset_h = move_toward($Camera2D.offset_h, 0, 1)
func cameraZoom():
	var close = 0.2
	var far   = 0.4
	if $cameraUp.is_colliding() == true && $cameraDown.is_colliding() == true:
		$Camera2D.zoom.x = lerp($Camera2D.zoom.x ,close, 0.2)
		$Camera2D.zoom.y = lerp($Camera2D.zoom.y ,close, 0.2)
	else:
		$Camera2D.zoom.x = lerp($Camera2D.zoom.x ,far, 0.2)
		$Camera2D.zoom.y = lerp($Camera2D.zoom.y ,far, 0.2)

func wallDetector():
	if Anim.flip_h == false:
		wallCast.global_rotation_degrees = 0
	elif Anim.flip_h == true:
		wallCast.global_rotation_degrees = 180
		
	if Input.is_action_pressed("left") && gR.is_colliding():
		slopeCast.rotation_degrees = 0
	elif Input.is_action_pressed("left") && !gR.is_colliding():
		slopeCast.rotation_degrees = 180
	elif Input.is_action_pressed("right") && gL.is_colliding():
		slopeCast.rotation_degrees = 180
	elif Input.is_action_pressed("right") && !gL.is_colliding():
		slopeCast.rotation_degrees = 0

# Extra Sprite/Animation Stuff
func _on_AnimatedSprite_animation_finished():
	#if "Walk" in Anim.get_animation():
		#starting_run = false
	if "Skid" in Anim.get_animation():
		starting_run = false
		if reverse_to_right == true:
			reverse_to_right = false
		if reverse_to_left == true:
			reverse_to_left = false
	if "toFall" in Anim.get_animation():
		start_fall = false
	if "Crouch" in Anim.get_animation():
		Anim.frame = 3
		pass
	pass

func rotateSprite():
	if is_on_floor():
			Anim.rotation = lerp(Anim.rotation, get_floor_normal().angle() + PI/2, 0.5)
			dash.rotation = lerp(dash.rotation, get_floor_normal().angle() + PI/2, 0.5)
	else:
		Anim.rotation = lerp(Anim.rotation, 0, 0.1)
		dash.rotation = lerp(dash.rotation, 0, 0.1)

# Fall Limit
func _on_Fall_limit_area_entered(area):
	get_tree().reload_current_scene()

# Debug
func debugText():
	var curRotation = Anim.rotation
	var curXvel = velocity.x
	var curYvel = velocity.y
	$DebugText/PlayerXvel.text = "Player X-Vel: " + str(curXvel) + "| " + str(MAX_SPEED)
	$DebugText/PlayerYvel.text = "Player Y-Vel: " + str(curYvel)
	$DebugText/PlayerAngle.text = "Player Angle: " + str(curRotation)
	$DebugText/Crouching.text = "Player Angle: " + str(curRotation)
