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

var cur_option = 0

func _ready():
	pass # Replace with function body.

func _process(delta):
	# Gamepad
	if cur_option == 1:
		startButton.grab_focus()
		if Input.is_action_just_pressed("jump"):
			music.stream_paused = true
			if !sfx_accept.playing:
				sfx_accept.play(0.0)
			SceneTransition.fade("res://World.tscn")
	elif cur_option == 2:
		settingsButton.grab_focus()
		if Input.is_action_just_pressed("jump"):
			if !sfx_select.playing:
				sfx_select.play(0.0)
			settings_menu.popup_centered()
	elif cur_option == 3:
		quitButton.grab_focus()
		if Input.is_action_just_pressed("jump"):
			music.stream_paused = true
			if !sfx_exit.playing:
				sfx_exit.play(0.0)
			SceneTransition.quit_game()
			
	if Input.is_action_just_pressed("down") && cur_option < 3:
		sfx_hover.play(0.0)
		cur_option += 1
	elif Input.is_action_just_pressed("up") && cur_option > -1:
		sfx_hover.play(0.0)
		cur_option -= 1
	
	# Normal Mouse
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

# Cursor
func _on_area_2d_area_entered(area):
	# Start Button
	if area.is_in_group("startButton"):
		sfx_hover.play(0.0)
		cur_option = 1
	else :
		cur_option = 0
	# Settings Button
	if area.is_in_group("settingsButton"):
		sfx_hover.play(0.0)
		cur_option = 2
	else :
		cur_option = 0
	# Exit Button
	if area.is_in_group("exitButton"):
		sfx_hover.play(0.0)
		cur_option = 3
	else :
		cur_option = 0
