extends Label

func _ready():
	Global.connect("fps_display", self._on_fps_display)
	
	
func _process(delta):
	text = "FPS: %s" % [Engine.get_frames_per_second()]

func _on_fps_display(value):
	visible = value
