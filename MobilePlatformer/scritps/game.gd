extends Node

@onready var dead_camera = $DeadCamera
@onready var player := $Player
@onready var spawn_point = $spawn_point

var coins = 0


func _ready():
	connect_coins()


func change_camera():
	var player_cam = player.get_node("Camera2D")
	dead_camera.enabled = true
	dead_camera.global_position = player_cam.global_position
	player_cam.enabled = false
	

func reset_camera():
	var player_cam : Camera2D = player.get_node("Camera2D")
	dead_camera.enabled = false
	player_cam.enabled = true


func connect_coins():
	for coin in $Coins.get_children():
		if coin.has_signal("collected"):
			coin.collected.connect(add_coins.bind())


func _on_player_died():
	change_camera()
	$RewspawnTimer.start()


func _on_rewspawn_timer_timeout():
	print("player respawned")
	player.revive(spawn_point.global_position)
	reset_camera()


func _on_end_body_entered(body):
	player.won()
	change_camera()
	
	$RewspawnTimer.start()

func add_coins(amount):
	coins += amount
	$HUD/Panel/CoinsLabel.text = str(coins)
