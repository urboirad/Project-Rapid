extends CharacterBody2D

const JUMP_VELOCITY = -300.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var direction = 1

var jumping = false


func _physics_process(delta):
	
	# Detect Player
	if $FrontCheck.is_colliding() && !jumping:
		jumping = true
		$Cooldown.start()
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if jumping and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	if jumping and !is_on_floor():
		jumping = false
		
	# Animation
	if direction == 1:
		$AnimatedSprite2D.flip_h = false
		$FrontCheck.target_position.x = 80
		$BackCheck.position.x = 0
	if direction == -1:
		$AnimatedSprite2D.flip_h = true
		$FrontCheck.target_position.x = -80
		$BackCheck.position.x = 80
	
	if velocity.y == 0:
		$AnimatedSprite2D.play("default")
		velocity.x = 0
	else:
		$AnimatedSprite2D.play("jump")
		if direction == 1:
			velocity.x += 5
		if direction == -1:
			velocity.x -= 5
	
	if $Cooldown.is_stopped():
		$FrontCheck.enabled = true
	else:
		$FrontCheck.enabled = false

	move_and_slide()


func _on_back_check_area_entered(area):
	if area.is_in_group("player"):
		direction = direction *-1
