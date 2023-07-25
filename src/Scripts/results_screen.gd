extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("enter")
	$AnimatedSprite2D.play("default")
	$Road.play("default")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$CanvasLayer/LabelTime.text = "TIME: " + GlobalVariables.lastTime
	$CanvasLayer/LabelScore.text = "SCORE: " + str(GlobalVariables.player_score)
	
	if Input.is_action_just_pressed("jump"):
		SceneTransition.quick_fade("res://Scenes/splash.tscn")
