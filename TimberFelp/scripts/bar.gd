extends Control

signal lost

@onready var progress_bar = $TextureProgressBar

var perc = 1

func _onready():
	set_process(true)


func _process(delta):
	if perc > 0:
		perc -= 0.1 * delta
		progress_bar.value = perc
	else:
		lost.emit()

func add(delta):
	perc = clamp(perc + delta, 0, 1)
