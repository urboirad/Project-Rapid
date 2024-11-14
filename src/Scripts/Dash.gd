extends Node2D

const dash_delay = 0.4

@onready var duration_timer = $DurationTimer
@onready var ghost_timer = $GhostTimer
var ghost_scene = preload("res://Scenes/DashGhost.tscn")
var can_dash = true
var sprite

var trail = false

func start_dash(sprite, duration):
	self.sprite = sprite
	
	duration_timer.wait_time = 0.15
	duration_timer.start()
	
	ghost_timer.start()
	instance_ghost()
	

func instance_ghost():
	var ghost: Sprite2D = ghost_scene.instantiate()
	get_parent().get_parent().add_child(ghost)
	
	var current_frame_index = sprite.frame
	var frame = sprite.frames.get_frame("Run", current_frame_index)
	ghost.texture = frame
	
	ghost.global_position = global_position
	ghost.flip_h = sprite.flip_h

func is_dashing():
	return !duration_timer.is_stopped()

func end_dash():
	ghost_timer.stop()
	
	can_dash = false
	await get_tree().create_timer(dash_delay).timeout
	can_dash = true

func _on_DurationTimer_timeout() -> void:
	end_dash()

func _on_GhostTimer_timeout() -> void:
	if trail:
		var trail_sprite = Sprite2D.new()
		trail_sprite.texture = load("res://assets/sprites/playerSprites.png")
		trail_sprite.vframes = 10
		trail_sprite.hframes = 8
		trail_sprite.frame = $Rotatable/Sprite2D.frame
		trail_sprite.scale.x = 2 * 1.2
		trail_sprite.scale.y = 2 * 1.2
		trail_sprite.scale.x = $Rotatable.scale.x * 2 * 1.2
		trail_sprite.set_script(load("res://assets/scripts/trail_fade.gd"))
		
		get_parent().add_child(trail_sprite)
		trail_sprite.position = position
		trail_sprite.modulate = Color( 1, 0.08, 0.58, 0.5 )
		trail_sprite.z_index = -49
