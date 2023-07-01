extends CharacterBody2D

const JUMP_VELOCITY = -300.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@export var direction = 1

var jumping = false

var dead = false


func _physics_process(delta):
	
	if !dead:
		# Detect Player
		if $FrontCheck.is_colliding() && !jumping:
			jumping = true
			$Cooldown.start()
			pass
			
		
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
	else:
		var knockback = 500
		$FloorBox.disabled = true
		$AnimatedSprite2D.play("hurt")
		$AnimatedSprite2D.rotation_degrees += 10
		velocity.y += gravity * delta
		if $AnimatedSprite2D.flip_h:
			velocity.x = knockback
		else:
			velocity.x = -knockback
			

	move_and_slide()


func _on_back_check_area_entered(area):
	if area.is_in_group("player"):
		direction = direction *-1


func _on_hit_box_area_entered(area):
	var knockback = 300
	if area.is_in_group("player"):
		if dead == false:
			$FloorBox.disabled = true
			if $AnimatedSprite2D.flip_h:
				$HitBox/CollisionShape2D.disabled = true
				velocity.y = JUMP_VELOCITY
				velocity.x -= -knockback
			else:
				$HitBox/CollisionShape2D.disabled = true
				velocity.y = JUMP_VELOCITY
				velocity.x += knockback
			if GlobalVariables.player_dashing:
				$despawn.start()
				GlobalVariables.camera.shake(0.2,1)
				dead = true
				$HitBox/CollisionShape2D.disabled = true
				$sfx_hit.play()
				
	else :
		$FloorBox.disabled = false
		$HitBox/CollisionShape2D.disabled = false



func _on_despawn_timeout():
	print("Arachnix Erased")
	self.queue_free()
