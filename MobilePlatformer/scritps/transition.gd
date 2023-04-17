extends CanvasLayer

var next_path

func fade_to(path):
	next_path = path
	$AnimationPlayer.play("fade_in")
	await $AnimationPlayer.animation_finished 
	change_scene()
	$AnimationPlayer.play("fade_out")

func change_scene():
	if next_path != null:
		get_tree().change_scene_to_file(next_path)
		

