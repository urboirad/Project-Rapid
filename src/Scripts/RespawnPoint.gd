extends Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	print(Input.get_joy_name(0))
	visible = false
	GlobalVariables.RespawnX = position.x
	GlobalVariables.RespawnY = position.y


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
