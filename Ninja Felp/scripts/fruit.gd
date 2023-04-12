extends RigidBody2D

class_name Fruit

signal score
signal life

@onready var shape = $CollisionShape2D
@onready var sprite0 = $Sprite0

@onready var body1 = $Body1
@onready var body2 = $Body2

@onready var sprite1 = $Body1/Sprite1
@onready var sprite2 = $Body2/Sprite2

var is_cut := false

func _ready():
	body1.freeze = true
	body2.freeze = true
	sprite1.hide()
	sprite2.hide()


func _process(delta):
	if position.y > 800:
		print("perde")
		life.emit()
		queue_free()
		
	if body1.position.y > 800 and body2.position.y > 800:
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
	if is_cut:
		return

	is_cut = true
	
	score.emit()
	
	sprite0.hide()
	sprite1.show()
	sprite2.show()
	freeze = true
	
	body1.freeze = false
	body2.freeze = false
	
	body1.apply_impulse( Vector2(-100, 0).rotated(rotation), Vector2(0, 0))
	body2.apply_impulse( Vector2(100, 0).rotated(rotation), Vector2(0, 0))
	
	body1.angular_velocity = angular_velocity
	body2.angular_velocity = angular_velocity

