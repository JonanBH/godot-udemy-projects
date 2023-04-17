extends Path2D


@export var speed = 50

@onready var path_follow = $Follow
var sign = 1
var is_dead = false

func _physics_process(delta):
	if is_dead :
		return
		
	var new_offset = path_follow.progress_ratio + delta * sign * speed/60
	if sign > 0 and new_offset > 0.9999:
		sign = -1
	elif sign < 0 and new_offset < 0.001:
		sign = 1
	
	path_follow.progress_ratio = new_offset
	$Follow/Enemy/Sprite2D.flip_h = sign > 0


func _on_enemy_died():
	is_dead = true
	$Follow/Enemy/HitFX.animation_finished.connect(remove.bind())


func remove():
	print("enemy destroyed")
	queue_free()
