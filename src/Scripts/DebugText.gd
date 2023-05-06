extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	$CurFPS.text = "FPS: " + str(Engine.get_frames_per_second())
	$FramesDrawn.text = "Frames Drawn: " + str(Engine.get_frames_drawn())
