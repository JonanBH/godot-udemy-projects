extends Node2D

func hit_from(direction : Felpudo.SIDE):
	if direction == Felpudo.SIDE.LEFT:
		if $AnimationPlayer.has_animation("right"):
			$AnimationPlayer.play("right")
		else:
			$AnimationPlayer.play("barrel/right")
	elif direction == Felpudo.SIDE.RIGHT:
		if $AnimationPlayer.has_animation("left"):
			$AnimationPlayer.play("left")
		else:
			$AnimationPlayer.play("barrel/left")
