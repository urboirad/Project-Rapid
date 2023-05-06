extends Node

func _ready():
	print(self.get_path())

func check_walls_collisions(entity, offset):
	var walls = get_tree().get_nodes_in_group("Walls")
	for wall in walls:
		if entity.hitbox.intersects(wall.hitbox, offset):
			return true
		return false
