extends CanvasLayer

func fade(target: String) -> void:
	$AnimationPlayer.play("dissolve")
	await $AnimationPlayer.animation_finished
	get_tree().change_scene_to_file(target)
	$AnimationPlayer.play_backwards("dissolve")

func quick_fade(target: String) -> void:
	$AnimationPlayer.play("dissolve_fast")
	await $AnimationPlayer.animation_finished
	get_tree().change_scene_to_file(target)
	$AnimationPlayer.play_backwards("dissolve_fast")

func quit_game():
	$AnimationPlayer.play("dissolve")
	await $AnimationPlayer.animation_finished
	get_tree().quit()
