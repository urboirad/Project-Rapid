extends Node

signal fps_display(value)

func toggle_fullscreen(value):
	if value:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	pass
	
func toggle_vsync(value):
	if value:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
		
func toggle_fps_display(value):
	emit_signal("fps_display", value)

func set_max_fps(value):
	if value < 500:
		Engine.max_fps = value
		
func update_master_vol(vol):
	AudioServer.set_bus_volume_db(0, vol)
	
func update_music_vol(vol):
	AudioServer.set_bus_volume_db(1, vol)
	
func update_sfx_vol(vol):
	AudioServer.set_bus_volume_db(2, vol)
