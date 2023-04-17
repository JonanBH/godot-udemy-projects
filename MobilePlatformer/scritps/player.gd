class_name Player extends CharacterBody2D


signal coin_collected()
signal died

const WALK_SPEED = 200.0
const ACCELERATION_SPEED = WALK_SPEED * 6.0
const JUMP_VELOCITY = -400.0
## Maximum speed at which the player can fall.
const TERMINAL_VELOCITY = 400
const BOUNCE_FORCE = -500.0

## The player listens for input actions appended with this suffix.[br]
## Used to separate controls for multiple players in splitscreen.
@export var action_suffix := ""

var gravity: int = ProjectSettings.get("physics/2d/default_gravity")
@onready var sprite := $Sprite as AnimatedSprite2D
#@onready var camera := $Camera as Camera2D
var _double_jump_charged := false

var is_alive = true
var level_complete = false


func _physics_process(delta: float) -> void:
	velocity.y = minf(TERMINAL_VELOCITY, velocity.y + gravity * delta)
	if is_alive:
		
		if is_on_floor():
			_double_jump_charged = true
		if Input.is_action_just_pressed("jump" + action_suffix):
			try_jump()
		elif Input.is_action_just_released("jump" + action_suffix) and velocity.y < 0.0:
			# The player let go of jump early, reduce vertical momentum.
			velocity.y *= 0.6
		

		var direction := Input.get_axis("move_left" + action_suffix, "move_right" + action_suffix) * WALK_SPEED
		if level_complete:
			direction = WALK_SPEED
			
		velocity.x = move_toward(velocity.x, direction, ACCELERATION_SPEED * delta)

		if not is_zero_approx(velocity.x):
			if velocity.x > 0.0:
				sprite.scale.x = 1.0
			else:
				sprite.scale.x = -1.0
		sprite.animation = get_new_animation()
		
	# Fall.
	
	
	move_and_slide()



func get_new_animation() -> String:
	var animation_new: String
	if is_on_floor():
		if absf(velocity.x) > 0.1:
			animation_new = "run"
		else:
			animation_new = "idle"
	else:
		if velocity.y > 0.0:
			animation_new = "falling"
		else:
			animation_new = "jumping"
	return animation_new


func try_jump() -> void:
	if is_on_floor():
		pass
	elif _double_jump_charged:
		_double_jump_charged = false
		velocity.x *= 2.5
	else:
		return
	velocity.y = JUMP_VELOCITY


func _on_feet_body_entered(body):
	if velocity.y <= 0 or not is_alive:
		return
		
	body.stomp()
	velocity.y = BOUNCE_FORCE


func _on_body_body_entered(body):
	die()
	
	
func die():
	if not is_alive:
		return
	
	is_alive = false
	velocity.y = -500
	velocity.x = 0
	
	$CollisionShape2D.set_deferred("disabled", true)
	$Feet/CollisionShape2D.set_deferred("disabled", true)
	$Body/CollisionShape2D.set_deferred("disabled", true)
	died.emit()


func _on_head_body_entered(body):
	if body.has_method("destroy"):
		body.destroy()


func revive(position):
	is_alive = true
	level_complete = false
	
	$CollisionShape2D.set_deferred("disabled", false)
	$Feet/CollisionShape2D.set_deferred("disabled", false)
	$Body/CollisionShape2D.set_deferred("disabled", false)
	
	velocity = Vector2.ZERO
	self.position = position


func won():
	level_complete = true
