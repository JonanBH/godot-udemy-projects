extends Node2D

@export var speed = -100
@onready var scene : Game = get_tree().current_scene

func _physics_process(delta):
	
	if scene.state == Game.STATE.LOST:
		return
	
	
	position += Vector2(speed * delta, 0)
	
	if position.x < -200 :
		print("cano destruido")
		queue_free()


func _on_area_2d_body_entered(body):
	if body.name == "Felpudo":
		scene.kill()
	pass # Replace with function body.


func _on_ponto_body_entered(body):
	if body.name == "Felpudo":
		scene.add_points(1)
