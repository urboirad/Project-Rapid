extends Popup

# Video Settings
@onready var display_options = $SettinTabs/Video/MarginContainer/VideoSettings/DisplayOptionButton
@onready var vsync_btn = $SettinTabs/Video/MarginContainer/VideoSettings/VsyncBtn
@onready var display_fps_btn = $SettinTabs/Video/MarginContainer/VideoSettings/DisplayFPSbtn
@onready var max_fps_val = $SettinTabs/Video/MarginContainer/VideoSettings/HBoxContainer/MaxFPSVal
@onready var max_fps_slider = $SettinTabs/Video/MarginContainer/VideoSettings/HBoxContainer/MaxFPSSlider

# Audio Settings
@onready var master_vol_slider = $SettinTabs/Audio/MarginContainer/AudioSettings/MasterVolumeSlider
@onready var music_vol_slider = $SettinTabs/Audio/MarginContainer/AudioSettings/MusicVolumeSlider
@onready var sfx_vol_slider = $SettinTabs/Audio/MarginContainer/AudioSettings/SFXVolumeSlider

# Gameplay Settings

func _ready():
	pass


func _on_display_option_button_item_selected(index):
	Global.toggle_fullscreen(true if index == 1 else false)


func _on_vsync_btn_toggled(button_pressed):
	Global.toggle_vsync(button_pressed)

func _on_display_fp_sbtn_toggled(button_pressed):
	Global.toggle_fps_display(button_pressed)

func _on_max_fps_slider_value_changed(value):
	Global.set_max_fps(value)
	max_fps_val.text = str(value) if value < max_fps_slider.max_value else "max"


func _on_master_volume_slider_value_changed(value):
	Global.update_master_vol(value)


func _on_music_volume_slider_value_changed(value):
	Global.update_music_vol(value)


func _on_sfx_volume_slider_value_changed(value):
	Global.update_sfx_vol(value)


func _on_laguage_option_button_item_selected(index):
	Global.toggle_language(index)
	pass
