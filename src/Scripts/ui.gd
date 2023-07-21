extends Control

# Timer
var time_elapsed = 0
var minutes = 0.0
var seconds = 0.0
var milliseconds = 0.0
var timeLabel = ""

# Energy Bar
@onready var energyBarAnim = $EnergyBarBack

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Energy Bar
	var energyBar = $EnergyBar
	energyBar.value = GlobalVariables.player_energy
	
	if GlobalVariables.player_energy > 0:
		energyBarAnim.play("default")
	else:
		energyBarAnim.play("drained")
	
	# Timer
	time_elapsed += delta
	minutes = time_elapsed / 60
	seconds = fmod(time_elapsed,60)
	milliseconds = fmod(time_elapsed,1)*100
	timeLabel = "%02d:%02d:%02d" % [minutes, seconds, milliseconds]
	$Container/Top/TimerLabel.text = timeLabel
	
	
	GlobalVariables.lastTime = timeLabel
	
	# Score
	$Container/Top/ScoreLabel.text = str(GlobalVariables.player_score)
	
