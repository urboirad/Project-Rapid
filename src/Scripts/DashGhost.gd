extends Sprite2D

var tween = create_tween()

func _ready():
	tween.tween_property(self, "modulate:a", 1.0, 0.5)
	#tween.

func _physics_process(delta):
	pass

func _on_Tween_tween_completed(object, key):
	queue_free()
