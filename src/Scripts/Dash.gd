extends Node2D

const dash_delay = 0.4

onready var duration_timer = $DurationTimer
onready var ghost_timer = $GhostTimer
var ghost_scene = preload("res://Scenes/DashGhost.tscn")
var can_dash = true
var sprite

func start_dash(sprite, duration):
	self.sprite = sprite
	
	duration_timer.wait_time = 0.15
	duration_timer.start()
	
	ghost_timer.start()
	instance_ghost()
	

func instance_ghost():
	var ghost: Sprite = ghost_scene.instance()
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
	yield(get_tree().create_timer(dash_delay), "timeout")
	can_dash = true

func _on_DurationTimer_timeout() -> void:
	end_dash()

func _on_GhostTimer_timeout() -> void:
	instance_ghost()
