extends Node

var camera : Camera2D
var player : CharacterBody2D

var energy_tick = false

var player_dashing = false

var player_energy = 100
var player_score = 0
var previous_time = ""

var dia_isTalking = ""

var RespawnX = 0
var RespawnY = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	# Energy Bar Tick
	if energy_tick:
		if player_energy > 0:
			player_energy -= 0.1
