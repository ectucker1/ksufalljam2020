extends Node


const TRAUMA_DECAY_RATE := 0.3

const HITSTOP_SPEED := 0.1

# Screenshake magnitude
var trauma := 0.0 setget set_trauma

var hitstop_time := 0.0

func _process(delta):
	trauma -= delta * TRAUMA_DECAY_RATE
	if trauma < 0.0:
		trauma = 0.0

	hitstop_time -= delta / HITSTOP_SPEED
	if hitstop_time < 0:
		Engine.time_scale = 1.0
	else:
		Engine.time_scale = HITSTOP_SPEED

func set_trauma(value):
	trauma = clamp(value, 0.0, 1.0)

func hitstop(time):
	hitstop_time = max(hitstop_time, time)
