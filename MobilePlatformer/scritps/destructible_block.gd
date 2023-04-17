extends StaticBody2D


func destroy():
	$CollisionShape2D.set_deferred("disabled", true)
	$AnimationPlayer.play("destroy")
	$AnimationPlayer.animation_finished.connect(destroy_body.bind())


func destroy_body(name):
	queue_free()
