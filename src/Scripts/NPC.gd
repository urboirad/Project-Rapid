extends AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	self.play("default")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_area_entered(area):
	if area.is_in_group("player") && GlobalVariables.dia_isTalking == "":
		DialogHud.say_Test("Iris", 1)
