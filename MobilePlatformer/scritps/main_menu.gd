extends Node


func _on_texture_button_pressed():
	print("starting")
	Transition.fade_to("res://scenes/game.tscn")
	#get_tree().change_scene_to_file()
