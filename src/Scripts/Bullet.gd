extends Node2D

@export var direction = 1
@export var speed = 5
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$AnimatedSprite2D.play("default")
	if direction == 1:
		position.x -= speed
	if direction == -1:
		position.x += speed


func _on_hit_box_area_entered(area):
	if area.is_in_group("player"):
		queue_free()

func _on_hit_box_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body.is_in_group("floor"):
		queue_free()
