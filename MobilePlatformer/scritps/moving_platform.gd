extends Path2D

@export var speed : float = 30.0
@export var delay : float = 1.0

var sign = 1
var can_move = true

@onready var path_follow = $PathFollow2D

func _ready():
	$MoveDelay.wait_time = delay


func _physics_process(delta):
	if !can_move:
		return
		
	var new_progress = path_follow.progress_ratio + delta * sign * speed/60
	if sign > 0 and new_progress > 0.9999:
		new_progress = 1
		sign = -1
		can_move = false
		$MoveDelay.start()
		
	elif sign < 0 and new_progress < 0.001:
		new_progress = 0
		sign = 1
		can_move = false
		$MoveDelay.start()

	path_follow.progress_ratio = new_progress

func _on_move_delay_timeout():
	can_move = true
