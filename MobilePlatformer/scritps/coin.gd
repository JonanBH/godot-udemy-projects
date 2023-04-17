extends Area2D

signal collected(amount)

var is_collected = false

func _on_body_entered(body):
	if is_collected:
		return
		
	is_collected = true
	var tween = create_tween()
	tween.tween_property($CoinSprite, "scale", Vector2.ZERO, 0.3)
	tween.play()
	collected.emit(1)
	
	$FXSprite.play()
	$FXSprite.show()
	$FXSprite.animation_finished.connect(destroy.bind())
	
func destroy():
	print("coin destroyed")
	queue_free()
