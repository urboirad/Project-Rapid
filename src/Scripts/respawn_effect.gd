extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	#$AnimationPlayer.play("main")
	$ColorRect.scale.x = 0
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func play():
	$AnimationPlayer.play("main")
