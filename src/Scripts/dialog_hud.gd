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
		
	if text.visible_characters == text.get_total_character_count() && spell:
		spell = false
		
	# Dialog Switch
	if curDia == "test" && curDiaLine == 2:
		say_Test2("Iris", 1)

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
