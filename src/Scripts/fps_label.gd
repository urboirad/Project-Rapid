extends Label
@onready var rain = preload("res://Scenes/weather.tscn").instantiate()

func _ready():
	Global.connect("fps_display", self._on_fps_display)
	
	
func _process(delta):
	text = "FPS: %s" % [Engine.get_frames_per_second()]

func _on_fps_display(value):
	visible = value


func _on_rain_trigger_area_entered(area):
	if area.is_in_group("player"):
		get_parent().add_child(rain)
		queue_free()
