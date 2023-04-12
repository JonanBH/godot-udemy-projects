extends RigidBody2D

@export var fly_force = 100

var is_playing = true

func _ready():
	set_process_input(true)
	pass
	
	
func _input(event):
	if(is_playing == false):
		return
		
	if event.is_action_pressed("touch"):
		on_touch()

func on_touch():
	apply_impulse(Vector2(0, -fly_force))


func kill():
	apply_impulse(Vector2(-1000, 0), Vector2(0, 0))
