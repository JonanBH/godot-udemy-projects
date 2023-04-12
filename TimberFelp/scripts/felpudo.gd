extends Node2D

class_name Felpudo

@onready var idle = $Idle
@onready var hit_spr = $Hit
@onready var anim = $AnimationPlayer
@onready var grave = $Grave

enum SIDE{
	LEFT,
	RIGHT
}

var side : SIDE = SIDE.LEFT

func _ready():
	pass
	
	
func set_side(new_side : SIDE):
	side = new_side
	match new_side:
		SIDE.LEFT:
			idle.flip_h = false
			hit_spr.flip_h = false
			
			position = Vector2(220, 1070)
			grave.position = Vector2(-44, 41)
			grave.flip_h = true
		
		SIDE.RIGHT:
			idle.flip_h = true
			hit_spr.flip_h = true
			
			position = Vector2(500, 1070)
			grave.position = Vector2(28, 41)
			grave.flip_h = false


func hit():
	anim.play("hit")


func die():
	anim.pause()
	idle.hide()
	hit_spr.hide()
	grave.show()
