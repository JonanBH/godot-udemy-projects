extends Node2D

@export var max_random_variation = 300

var cano = preload("res://Scenes/cano.tscn")

func _ready():
	randomize()
	


func _on_timer_timeout():
	_spawn_pipe()


func _spawn_pipe():
	var offset = randf_range(-max_random_variation, max_random_variation)
	var pipe = cano.instantiate()
	
	self.add_child(pipe)
	pipe.position = $Marker2D.position + Vector2(0, offset)
	
