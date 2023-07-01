extends AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	self.play("default")
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	pass


func _on_area_2d_area_entered(area):
	if area.is_in_group("player"):
		if GlobalVariables.player_energy < 100:
			GlobalVariables.player_energy += 10
		queue_free()
