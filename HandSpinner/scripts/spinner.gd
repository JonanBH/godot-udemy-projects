extends Node2D

signal speed_update(speed, max_speed)
signal max_speed_reached
signal zero_speed_reached

@export var min_speed : float = 0.0
@export var max_speed : float = 360.0
@export var speed_increment : float = 5.0
@export var drag : float = 7.0
var vel = 0.0

var reset = false
var reset_signaled = false


func _ready():
	reset_spinner()


func _process(delta):
	if vel < 0.01:
		vel = 0
		
		if reset and !reset_signaled:
			zero_speed_reached.emit()
			reset_signaled = true
		return
	rotate(deg_to_rad(vel))
	
	$body.rotate(deg_to_rad(vel * delta))
	speed_update.emit(vel, max_speed)
	
	var drag_delta = delta
	if reset:
		drag_delta *= 2
		
	apply_drag(drag_delta)

func _on_contact_input_event(_viewport, event, _shape_idx):
	if reset:
		return
	if event is InputEventScreenTouch and event.pressed:
		vel = clamp (vel + speed_increment, min_speed, max_speed)
		
		if vel == max_speed:
			max_speed_reached.emit()


func apply_drag(delta):
	vel = clamp(vel - delta * drag, min_speed, max_speed)


func _on_btn_black_pressed():
	$body/sprite.texture = load("res://assets/black_ready.png")

func _on_btn_red_pressed():
	$body/sprite.texture = load("res://assets/red_ready.png")


func _on_btn_yellow_pressed():
	$body/sprite.texture = load("res://assets/yellow_ready.png")


func reset_spinner():
	reset = true
	reset_signaled = false
	

func unblock():
	reset = false
