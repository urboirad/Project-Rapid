extends CharacterBody2D

@export var direction = 1
@export var bullet = preload("res://Scenes/bullet.tscn")
var shooting = false
var dead = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	
	# Animation
	if direction == 1 && !dead:
		$AnimatedSprite2D.flip_h = false
		$BackCheck/CollisionShape2D.position.x = 33
		$FrontCheck/CollisionShape2D.position.x = -17.5
	if direction == -1 && !dead:
		$AnimatedSprite2D.flip_h = true
		$BackCheck/CollisionShape2D.position.x = -32
		$FrontCheck/CollisionShape2D.position.x = 19
	
	# Checks if shooting
	if shooting:
		$AnimatedSprite2D.play("shoot")
		if $AnimatedSprite2D.flip_h == false:
			rotation_degrees = lerp(rotation_degrees, -10.0, 0.5)
		if $AnimatedSprite2D.flip_h == true:
			rotation_degrees = lerp(rotation_degrees, 10.0, 0.5)
		if $AnimatedSprite2D.animation == "shoot" && $AnimatedSprite2D.frame == 0:
			$BulletSpawn.start()
			$sfx_shoot.play()
	else:
		$AnimatedSprite2D.play("default")
		rotation_degrees = lerp(rotation_degrees, 0.0, 0.5)
	
	# Checks if dead
	if dead:
		var knockback = 400
		$AnimatedSprite2D.play("hurt")
		$AnimatedSprite2D.rotation_degrees += 10
		velocity.y += gravity * delta
		if $AnimatedSprite2D.flip_h:
			velocity.x = -knockback
		else:
			velocity.x = knockback

	move_and_slide()


func _on_hit_box_area_entered(area):
	var knockback = 10
	if area.is_in_group("player"):
		if !dead or !GlobalVariables.player_dashing:
			$FloorBox.call_deferred("is_disabled", true)
			$HitBox/CollisionShape2D.call_deferred("is_disabled", true)
			if GlobalVariables.player_dashing:
				$FloorBox.queue_free()
				$HitBox/CollisionShape2D.queue_free()
				$FrontCheck/CollisionShape2D.queue_free()
				$BackCheck/CollisionShape2D.queue_free()
				$despawn.start()
				GlobalVariables.player_energy += 20
				GlobalVariables.camera.shake(0.2,1)
				dead = true
				$sfx_hit.play()
				
	else :
		$FloorBox.call_deferred("is_disabled", false)
		$HitBox/CollisionShape2D.call_deferred("is_disabled", false)


func _on_back_check_area_entered(area):
	if area.is_in_group("player"):
		direction = direction *-1


func _on_despawn_timeout():
	queue_free()


func _on_front_check_area_entered(area):
	if area.is_in_group("player"):
		shooting = true
func _on_front_check_area_exited(area):
	if area.is_in_group("player"):
		shooting = false


func _on_bullet_spawn_timeout():
	var  b = bullet.instantiate()
	call_deferred("add_child",b)
	b.position.y += 14
	if $AnimatedSprite2D.flip_h == false:
		b.position.x -= 15
		b.direction = 1
		b.rotation_degrees = self.rotation_degrees
	if $AnimatedSprite2D.flip_h == true:
		b.direction = -1
		b.rotation_degrees = self.rotation_degrees
		b.position.x += 14
