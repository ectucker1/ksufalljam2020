class_name WarpDriveMutation
extends Mutation


const COOLDOWN := 1.4

const MIN_X := -128.0
const MAX_X := 128.0
const MIN_Y := -128.0
const MAX_Y := 128.0

var timeout := 0.0


func get_name():
	return "Warp Drive"

func physics_process(delta):
	timeout -= delta

func on_used():
	if timeout <= 0.0:
		timeout = COOLDOWN
		var x = rand_range(MIN_X, MAX_X)
		var y = rand_range(MIN_Y, MAX_Y)
		player.global_position = Vector2(x, y)
