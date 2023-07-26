extends CharacterBody2D

@export var direction = 1

@onready var vfx_hit = preload("res://Scenes/vfx_hit.tscn")
@onready var vfx_hitSpark = preload("res://Scenes/vfx_hit_spark.tscn")
@onready var explosion = preload("res://Scenes/vfx_explosion.tscn")

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var speed = 5

var trans = 0
var charging = false
var dead = false

func _ready():
	pass
	
func _physics_process(delta):
	$Label.text = str(trans)
	
	velocity.y += gravity * delta
	
	# Animation
	if direction == 1 && !dead:
		$AnimatedSprite2D.flip_h = false
		$HammerBox/CollisionShape2D.position.x = -17.5
		$FrontCheck/CollisionShape2D.position.x = -26
		#$FC/cs2d.position.x = -26
	if direction == -1 && !dead:
		$AnimatedSprite2D.flip_h = true
		$HammerBox/CollisionShape2D.position.x = 17.5
		$FrontCheck/CollisionShape2D.position.x = 30
		#$FC/cs2d.position.x = 30
		
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
	else:
		if !charging:
			$AnimatedSprite2D.play("idle")
		else:
			$HammerBox/CollisionShape2D.disabled = false
			$FrontCheck/CollisionShape2D.disabled = true
			if trans == 0 && $AnimatedSprite2D.animation == "idle":
				$AnimatedSprite2D.play("transition")
			if trans == 1:
				$HammerBox/CollisionShape2D.disabled = false
				$AnimatedSprite2D.play("moving")
				if direction == 1:
					velocity.x -= speed
				if direction == -1:
					velocity.x += speed
			
	move_and_slide()


func _on_despawn_timeout():
	queue_free()


func _on_hit_box_area_entered(area):
	if area.is_in_group("player"):
		if !dead or !GlobalVariables.player_dashing:
			$FloorBox.disabled = true
			$HitBox/CollisionShape2D.disabled = true
			if GlobalVariables.player_dashing:
				var s = vfx_hitSpark.instantiate()
				var h = vfx_hit.instantiate()
				get_parent().add_child(s)
				get_parent().add_child(h)
				s.position = position
				h.position = position
				h.position.y = position.y - 20
				$FloorBox.queue_free()
				$HitBox/CollisionShape2D.queue_free()
				$FrontCheck/CollisionShape2D.queue_free()
				$despawn.start()
				GlobalVariables.player_energy += 20
				GlobalVariables.camera.shake(0.2,1)
				GlobalVariables.player_score += 100
				dead = true
				$sfx_hit.play()
				
func _on_animated_sprite_2d_animation_finished():
	if $AnimatedSprite2D.animation == "transition":
		trans = 1


func _on_hammer_box_body_entered(body):
	if not body.is_in_group("player"):
		if charging && trans == 1:
			var e = explosion.instantiate()
			get_parent().add_child(e)
			$sfx_exlpode.play()
			e.position = position
			queue_free()
	if body.is_in_group("player") && !GlobalVariables.player_dashing:
		if direction == 1:
			velocity.x = 0
			velocity.x = velocity.x + 200
		if direction == -1:
			velocity.x = 0
			velocity.x -= velocity.x - 200

func _on_front_check_area_entered(area):
	if area.is_in_group("player"):
		charging = true
