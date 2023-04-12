extends Node2D

class_name Game

var points : int = 0
var state : STATE = STATE.PLAYING

@onready var felpudo = $Felpudo

enum STATE{
	PLAYING,
	LOST,
}

func kill():
	felpudo.apply_impulse(Vector2(-1000, 0), Vector2(0, 0))
	$BackAnim.pause()
	state = STATE.LOST
	$TimeToReplay.start()


func _on_time_to_replay_timeout():
	get_tree().reload_current_scene()


func add_points(amount):
	points += amount
	update_score()
	

func update_score():
	$CanvasLayer/Score.text = "Score : " + str(points)
