extends Area2D

@onready var shape = $CollisionShape2D
@export var CameraLimit = 10000000


# Called when the node enters the scene tree for the first time.
func _ready():
	shape.global_scale.x = CameraLimit


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
