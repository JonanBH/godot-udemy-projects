extends Node2D

@onready var interval = $Interval
@onready var limit = $Limit

@export_flags_2d_physics var cut_layer

var pressed = false
var drag = false
var current_pos = Vector2(0, 0)
var last_pos = Vector2(0, 0)


func _ready():
	set_process_input(true)


func _input(event):
	event = make_input_local(event)
	if event is InputEventScreenTouch:
		event = event as InputEventScreenTouch
		
		if event.pressed:
			init_press(event.position)
		else:
			release()
	elif event is InputEventScreenDrag:
		event = event as InputEventScreenDrag
		update_drag(event.position)


func _physics_process(delta):
	queue_redraw()
	if drag and current_pos != last_pos and last_pos != Vector2(0,0):
		var space_state = get_world_2d().direct_space_state
		var params := PhysicsRayQueryParameters2D.new()
		params.from = last_pos
		params.to = current_pos
		params.collision_mask = cut_layer
		
		var result := space_state.intersect_ray(params)
		if not result.is_empty():
			result.collider.cut()


func init_press(pos):
	current_pos = pos
	last_pos = pos
	pressed = true
	
	limit.start()
	interval.start()


func release():
	limit.stop()
	interval.stop()
	current_pos = Vector2.ZERO
	last_pos = Vector2.ZERO
	pressed = false
	drag = false


func update_drag(pos):
	current_pos = pos
	drag = true


func _on_interval_timeout():
	last_pos = current_pos
	


func _on_limit_timeout():
	release()


func _draw():
	if drag and current_pos != last_pos and last_pos != Vector2(0,0):
		draw_line(current_pos, last_pos, Color(1, 0, 0),10)
