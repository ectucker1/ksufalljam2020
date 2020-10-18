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

func fade_out():
	$FadeLayer/AnimationPlayer.play("fade_out")

func fade_in():
	$FadeLayer/AnimationPlayer.play("fade_in")

func _input(event):
	if event.is_action_pressed("dev_fullscreen"):
		OS.window_fullscreen = not OS.window_fullscreen
