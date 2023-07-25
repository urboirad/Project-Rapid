extends Node2D

@onready var box = $CanvasLayer/ColorRect
@onready var por = $CanvasLayer/Portrait
@onready var text = $CanvasLayer/Text
@onready var ttimer = $CanvasLayer/TransTimer
@onready var ap = $AnimationPlayer
@onready var cl = $CanvasLayer

var spell = false

var spellSpeed = 0

var curDia = "" # Use this for multiple lines
var curDiaLine = 1

var finished = false

# Voice SFX
var cur_sound = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	box.scale.y = 0
	por.scale.y = 0
	text.visible = false
	#say_Test("Iris", 1)
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#$CanvasLayer/Label.text = str(por.scale.y)
	#$CanvasLayer/Label.text = GlobalVariables.dia_isTalking
	
	# Spawn Animation
	if ap.is_playing():
		if ap.current_animation == "in":
			if por.scale.y < 4:
				por.scale.y += 0.5
		if ap.current_animation == "out":
			por.scale.y -= 0.5
		
	if ap.animation_finished:
		if ap.current_animation == "in":
			por.scale.y = 4
		if ap.current_animation == "out":
			text.visible = false
			por.visible = false
		
	# Switch Portrait
	if GlobalVariables.dia_isTalking == "RAD":
		por.play("RAD")
		if !por.is_playing():
			por.play("RAD")
	if GlobalVariables.dia_isTalking == "Iris":
		por.play("Iris")
		if !por.is_playing():
			por.play("Iris")
			
	# Text Animation
	if spell:
		text.visible_characters += spellSpeed
		if GlobalVariables.dia_isTalking == "Iris":
			$IrisVoice.play()
		
	if text.visible_characters == text.get_total_character_count() && spell:
		spell = false
		
	# Dialog Switch
	if curDia == "test" && curDiaLine == 2:
		say_Test2("Iris", 1)
		
	if curDia == "tut1" && curDiaLine == 2:
		say_D2("Iris", 1)
		
	#if curDia == "tut3" && curDiaLine == 2:
		#say_D5("Iris", 1)
	#if curDia == "tut3" && curDiaLine == 3:
		#say_D6("Iris", 1)
	#if curDia == "tut3" && curDiaLine == 4:
		#say_D7("Iris", 1)

# Dialog

# -- Test Dialog --
func say_Test(character, speed):
	por.visible = true
	text.visible = true
	ap.play("in")
	curDia = "test"
	curDiaLine = 1
	GlobalVariables.dia_isTalking = character
	text.visible_characters = 0
	text.text = "This is test dialog. This also tests the portrait system as well. :O"
	spell = true
	spellSpeed = speed
	ttimer.start()
	await ttimer.timeout
	curDiaLine = 2
func say_Test2(character, speed):
	text.visible = true
	curDia = "test"
	curDiaLine = 3
	GlobalVariables.dia_isTalking = character
	text.visible_characters = 0
	text.text = "This is the second test dialog. :O"
	spell = true
	spellSpeed = speed
	ttimer.start()
	await ttimer.timeout
	ap.play("out")
	GlobalVariables.dia_isTalking = ""
	curDia = ""
	
func say_D1(character, speed):
	por.visible = true
	text.visible = true
	ap.play("in")
	curDia = "tut1"
	curDiaLine = 1
	GlobalVariables.dia_isTalking = character
	text.visible_characters = 0
	text.text = "Hey Rapid! Its Iris. The core were looking for should be somewhere in this forest."
	spell = true
	spellSpeed = speed
	ttimer.start()
	await ttimer.timeout
	curDiaLine = 2
	
func say_D2(character, speed):
	por.visible = true
	text.visible = true
	ap.play("in")
	curDia = "tut1"
	curDiaLine = 3
	GlobalVariables.dia_isTalking = character
	text.visible_characters = 0
	if Input.get_joy_name(0) == "":
		text.text = "To get going you can use the Arrow Keys to move."
	else:
		text.text = "To get going you can use the Left Joystick to move."
	spell = true
	spellSpeed = speed
	ttimer.start()
	await ttimer.timeout
	ap.play("out")
	GlobalVariables.dia_isTalking = ""
	curDia = ""

func say_D3(character, speed):
	por.visible = true
	text.visible = true
	ap.play("in")
	curDia = "tut2"
	GlobalVariables.dia_isTalking = character
	text.visible_characters = 0
	if Input.get_joy_name(0) == "":
		text.text = "You can jump with [Z]."
	if Input.get_joy_name(0) == "PowerA Switch Controller":
		text.text = "You can jump with the (B) button."
	if Input.get_joy_name(0) == "PS4 Controller":
		text.text = "You can jump with the (X) button."
	if Input.get_joy_name(0) == "Xbox One Controller":
		text.text = "You can jump with the (A) button."
	spell = true
	spellSpeed = speed
	ttimer.start()
	await ttimer.timeout
	ap.play("out")
	GlobalVariables.dia_isTalking = ""
	curDia = ""

func say_D4(character, speed):
	por.visible = true
	text.visible = true
	ap.play("in")
	curDia = "tut3"
	#curDiaLine = 1
	GlobalVariables.dia_isTalking = character
	text.visible_characters = 0
	text.text = "Those boots are pretty awesome arent they."
	spell = true
	spellSpeed = speed
	ttimer.start()
	await ttimer.timeout
	#curDiaLine = 2
	say_D5("Iris",1)
	
func say_D5(character, speed):
	por.visible = true
	text.visible = true
	ap.play("in")
	curDia = "tut3"
	#curDiaLine = 3
	GlobalVariables.dia_isTalking = character
	text.visible_characters = 0
	text.text = "You can charge your jump by holding down and holding the jump button. Releasing any will give you some height."
	spell = true
	spellSpeed = speed
	ttimer.start()
	await ttimer.timeout
	#curDiaLine = 4
	say_D6("Iris",1)

func say_D6(character, speed):
	por.visible = true
	text.visible = true
	ap.play("in")
	curDia = "tut3"
	#curDiaLine = 5
	GlobalVariables.dia_isTalking = character
	text.visible_characters = 0
	text.text = "This uses alot of energy so use it wisely."
	spell = true
	spellSpeed = speed
	ttimer.start()
	await ttimer.timeout
	say_D7("Iris", 1)

func say_D7(character, speed):
	por.visible = true
	text.visible = true
	ap.play("in")
	curDia = "tut3"
	#curDiaLine = 5
	GlobalVariables.dia_isTalking = character
	text.visible_characters = 0
	if Input.get_joy_name(0) == "":
		text.text = "You can also dash with [X]."
	if Input.get_joy_name(0) == "PowerA Switch Controller" or Input.get_joy_name(0) == "Xbox One Controller":
		text.text = "You can also dash with the (Y) button"
	if Input.get_joy_name(0) == "PS4 Controller":
		text.text = "You can also dash with the (□) button."
	spell = true
	spellSpeed = speed
	ttimer.start()
	await ttimer.timeout
	ap.play("out")
	GlobalVariables.dia_isTalking = ""
	curDia = ""
	
func say_D8(character, speed):
	por.visible = true
	text.visible = true
	ap.play("in")
	curDia = "tut4"
	GlobalVariables.dia_isTalking = character
	text.visible_characters = 0
	text.text = "Seems you remember the basics. Don't forget that these boots are pretty hard to control. Good Luck."
	spell = true
	spellSpeed = speed
	ttimer.start()
	await ttimer.timeout
	ap.play("out")
	GlobalVariables.dia_isTalking = ""
	curDia = ""
	
func say_D9(character, speed):
	por.visible = true
	text.visible = true
	ap.play("in")
	curDia = "hint"
	GlobalVariables.dia_isTalking = character
	text.visible_characters = 0
	text.text = "One more thing try not to get hurt without any energy. It could be detremental."
	spell = true
	spellSpeed = speed
	ttimer.start()
	await ttimer.timeout
	ap.play("out")
	GlobalVariables.dia_isTalking = ""
	curDia = ""
