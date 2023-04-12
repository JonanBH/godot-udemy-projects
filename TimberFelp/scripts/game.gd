extends Node2D


@onready var felpudo : Felpudo = $Felpudo
@onready var camera = $Camera
@onready var barrels = $Barrels
@onready var dest_barrels = $DestBarrels
@onready var bar = $CanvasLayer/TimeBar

var barrel = preload("res://scenes/barrel.tscn")
var barrel_esq = preload("res://scenes/barrel_esq.tscn")
var barrel_dir = preload("res://scenes/barrel_dir.tscn")

var playing = true

var ult_ini
var points = 0

func _ready():
	set_process_input(true)
	randomize()
	generate_init()
	
func _input(event):
	if !playing:
		return
		
	event = camera.make_input_local(event)
	
	if event is InputEventScreenTouch and event.is_pressed():
		event = event as InputEventScreenTouch
		
		if event.position.x < 360:
			felpudo.set_side(Felpudo.SIDE.LEFT)
		else:
			felpudo.set_side(Felpudo.SIDE.RIGHT)
		
		if !hit_check():
			felpudo.hit()
			var prim = barrels.get_child(0)
			barrels.remove_child(prim)
			dest_barrels.add_child(prim)
			
			prim.hit_from(felpudo.side)
			random_barrel(Vector2(360, 1090 - 10 * 172))
			
			lower_barrels()
			bar.add(0.014)
			
			if hit_check():
				lost()
			else:
				points += 1
				update_points_label()
		
		else:
			lost()


func random_barrel(pos):
	var number = randi_range(0, 2)
	if ult_ini :
		number = 0
		
	generate_barrels(number, pos)


func generate_barrels(barrel_type, pos):
	var new_barrel
	match barrel_type:
		0:
			new_barrel = barrel.instantiate()
			ult_ini = false
		1:
			new_barrel = barrel_esq.instantiate()
			new_barrel.add_to_group("barrel_esq")
			ult_ini = true
		2:
			new_barrel = barrel_dir.instantiate()
			new_barrel.add_to_group("barrel_dir")
			ult_ini = true
			
	new_barrel.position = pos
	barrels.add_child(new_barrel)


func generate_init():
	for i in range(0, 3):
		generate_barrels(0, Vector2(360, 1090 - i * 172))
		
	for i in range(3, 10):
		random_barrel(Vector2(360, 1090 - i * 172))


func hit_check():
	var side = felpudo.side
	var prim = barrels.get_child(0)
	
	if (side == Felpudo.SIDE.LEFT and prim.is_in_group("barrel_esq")) or (side == Felpudo.SIDE.RIGHT and prim.is_in_group("barrel_dir")):
		return true
	
	return false


func lower_barrels():
	for b in barrels.get_children():
		b.position.y += 172


func lost():
	felpudo.die()
	playing = false
	bar.set_process(false)
	$ResetGame.start()


func _on_time_bar_lost():
	lost()


func update_points_label():
	$CanvasLayer/Points/PointLabel.text = str(points)


func _on_reset_game_timeout():
	get_tree().reload_current_scene()
