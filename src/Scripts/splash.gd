extends Node2D

func _on_timer_timeout():
	SceneTransition.quick_fade("res://Scenes/menu.tscn")
