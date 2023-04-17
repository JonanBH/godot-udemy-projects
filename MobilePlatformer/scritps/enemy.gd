extends CharacterBody2D

signal died

var is_alive = true

func stomp():
	if !is_alive:
		return
	
	is_alive = false
	died.emit()
	$AnimationPlayer.play("defeated")
	
	$HitFX.set_frame_and_progress(0,0)
	$HitFX.play("hit")
	$HitFX.show()
	
