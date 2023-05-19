extends Node2D

var sfxPlay = false

@onready var startButton = $Control/MarginContainer/VBoxContainer/StartButton
@onready var settingsButton = $Control/MarginContainer/VBoxContainer/SettingsButton
@onready var quitButton = $Control/MarginContainer/VBoxContainer/QuitButton

@onready var music = $MenuMusic

@onready var sfx_hover = $HoverSFX
@onready var sfx_select = $SelectSFX
@onready var sfx_accept = $ConfirmSFX
@onready var sfx_exit = $ExitSFX

@onready var settings_menu = $SettingsMenu

func _ready():
	pass # Replace with function body.

func _process(delta):
	
	if startButton.button_pressed:
		music.stream_paused = true
		if !sfx_accept.playing:
			sfx_accept.play(0.0)
		SceneTransition.fade("res://World.tscn")
			
	if settingsButton.button_pressed:
		if !sfx_select.playing:
			sfx_select.play(0.0)
		
	
	if quitButton.button_pressed:
		music.stream_paused = true
		if !sfx_exit.playing:
			sfx_exit.play(0.0)
		SceneTransition.quit_game()
		

func _on_start_button_mouse_entered():
	sfx_hover.play(0.0)

func _on_settings_button_mouse_entered():
	sfx_hover.play(0.0)

func _on_quit_button_mouse_entered():
	sfx_hover.play(0.0)


func _on_settings_button_pressed():
	settings_menu.popup_centered()
