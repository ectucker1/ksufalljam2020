extends Node


const TRAUMA_DECAY_RATE := 0.3

# Screenshake magnitude
var trauma := 0.0 setget set_trauma


func _process(delta):
	trauma -= delta * TRAUMA_DECAY_RATE
	if trauma < 0.0:
		trauma = 0.0

func set_trauma(value):
	trauma = clamp(value, 0.0, 1.0)
