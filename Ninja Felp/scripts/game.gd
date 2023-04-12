extends Node2D

@onready var fruits = $Fruits

@onready var fruit_scenes = [
	preload("res://scenes/avocado.tscn"), 
	preload("res://scenes/banana.tscn"),
	preload("res://scenes/orange.tscn"),
	preload("res://scenes/pear.tscn"),
	preload("res://scenes/pineapple.tscn"),
	preload("res://scenes/tomato.tscn"),
	preload("res://scenes/watermelon.tscn"),
	preload("res://scenes/bomb.tscn")]
	
@onready var live_sprites = [
	$HUD/HBoxContainer/TextureRect, 
	$HUD/HBoxContainer/TextureRect2, 
	$HUD/HBoxContainer/TextureRect3
]

var lifes = 3
var score = 0
var high_score : int = 0
var is_playing = true

func _ready():
	randomize()
	$HUD.show()
	$GameOverScreen.hide()
	_load_highscore()


func _input(event):
	if event is InputEventScreenTouch and !is_playing:
		get_tree().reload_current_scene()


func _on_timer_generator_timeout():
	var amount = randi_range(2, 4)
	
	for i in range(0, amount):
		spawn_random_fruit()


func spawn_random_fruit():
	if !is_playing:
		return
	
	var position = Vector2(randf_range(0, 1280), 750)
	var fruit = fruit_scenes.pick_random()
	
	var new_fruit = fruit.instantiate()
	new_fruit.life.connect(lose_life)
	
	if new_fruit.has_signal("score"):
		new_fruit.score.connect(add_score)
	
	if (!new_fruit):
		spawn_random_fruit()
		return
		
	fruits.add_child(new_fruit)
	new_fruit.spawn(position)


func lose_life():
	lifes = clamp(lifes - 1, 0, 3);
	update_lives()
	
	if lifes <= 0:
		lose()


func update_lives():
	for i in range(0, live_sprites.size()):
		live_sprites[i].visible = i < lifes


func add_score():
	if !is_playing:
		return
		
	
	score += 1
	$HUD/Label.text = str(score)


func _load_highscore():
	var dir = DirAccess.open("user://")
	if dir.file_exists("save.sav"):
		var save = FileAccess.open("user://save.sav", FileAccess.READ)
		high_score = save.get_var()


func _save_highscore():
	var save = FileAccess.open("user://save.sav", FileAccess.WRITE)
	save.store_var(high_score)


func lose():
	is_playing = false
	$InputProc.set_process(false)
	$InputProc.hide()
	$HUD.hide()
	$GameOverScreen.show()
	
	if score > high_score:
		$GameOverScreen/HighScoreLabel.text = "new high score"
		high_score = score
		_save_highscore()
	
	$GameOverScreen/HighScore.text = str(high_score)
