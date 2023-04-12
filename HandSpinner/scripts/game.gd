extends Node

var score1 = 0
var score2 = 0

var is_playing = true
var reseting = true

var spinner1_ok = false
var spinner2_ok = false

var waiting_time = 0

func _ready():
	$Spinner1.max_speed_reached.connect(_player1_score)
	$Spinner2.max_speed_reached.connect(_player2_score)
	_start_match_timer()


func update_score():
	$Control/P1/score.text = str(score1)
	$Control/P2/score.text = str(score2)


func _player1_score():
	score1 += 1
	$Control/P1/Message.text = "Você Ganhou"
	$Control/P2/Message.text = "Você Perdeu"
	update_score()
	reset_spinners()
	is_playing = false

func _player2_score():
	score2 += 1
	$Control/P1/Message.text = "Você Perdeu"
	$Control/P2/Message.text = "Você Ganhou"
	update_score()
	reset_spinners()
	is_playing = false


func reset_spinners():
	spinner1_ok = false
	spinner2_ok = false
	
	$Spinner1.reset_spinner()
	$Spinner2.reset_spinner()


func _on_spinner_1_zero_speed_reached():
	spinner1_ok = true
	print("spinner1 ready")
	
	_check_resets()

func _on_spinner_2_zero_speed_reached():
	spinner2_ok = true
	print("spinner2 ready")
	
	_check_resets()


func _check_resets():
	if spinner1_ok and spinner2_ok:
		_start_match_timer()


func _unlock_spinners():
	$Spinner1.unblock()
	$Spinner2.unblock()


func _start_match_timer():
	reseting = false
	is_playing = false
	waiting_time = 3
	
	$Control/P1/Message.text = str(waiting_time)
	$Control/P2/Message.text = str(waiting_time)
	$BetweenRounds.start()


func _on_between_rounds_timeout():
	if waiting_time == 0:
		_unlock_spinners()
		$BetweenRounds.stop()
		reseting = false
		is_playing = true
	
		$Control/P1/Message.text = ""
		$Control/P2/Message.text = ""
		
		return
	
	waiting_time -= 1
	
	$Control/P1/Message.text = str(waiting_time)
	$Control/P2/Message.text = str(waiting_time)
