extends RigidBody2D

signal life

var was_cut = false

func _ready():
	randomize()


func _process(delta):
	if position.y > 800:
		queue_free()


func spawn(pos):
	position = pos
	
	var init_speed = Vector2(0, randf_range(-1500, -1200))
	
	if pos.x < 640:
		init_speed = init_speed.rotated(deg_to_rad(randf_range(0, 30)))
	else:
		init_speed = init_speed.rotated(deg_to_rad(randf_range(0, -30)))
		
	linear_velocity = init_speed
	angular_velocity = randf_range(-10, 10)


func cut():
	if was_cut:
		return
	
	freeze = true
	life.emit()
	$AnimationPlayer.play("explode")
	was_cut = true
	
