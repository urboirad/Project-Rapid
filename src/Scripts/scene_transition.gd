extends CanvasLayer

func fade(target: String) -> void:
	$AnimationPlayer.play("dissolve")
	await $AnimationPlayer.animation_finished
	get_tree().change_scene_to_file(target)
	$AnimationPlayer.play_backwards("dissolve")

func quick_fade(target: String) -> void:
	if $ResultsMusic.playing:
		$MoveSFX.play()
	$AnimationPlayer.play("dissolve_fast")
	await $AnimationPlayer.animation_finished
	get_tree().change_scene_to_file(target)
	$AnimationPlayer.play_backwards("dissolve_fast")
	$ResultsMusic.stop()
	
func quick_fade_white(target: String) -> void:
	$ResultsMusic.play()
	$AnimationPlayer.play("dissolve_fast_white")
	await $AnimationPlayer.animation_finished
	get_tree().change_scene_to_file(target)
	$AnimationPlayer.play_backwards("dissolve_fast_white")

func quit_game():
	$AnimationPlayer.play("dissolve")
	await $AnimationPlayer.animation_finished
	get_tree().quit()
