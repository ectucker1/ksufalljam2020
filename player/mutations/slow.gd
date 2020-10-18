class_name SlowDownMutation
extends Mutation


func get_name():
	return "Molasses Knees"

func get_description():
	return "Slowww Down"

func on_attached():
	player.status.max_speed_mult *= 0.6
	player.status.acc_mult *= 0.6

func on_removed():
	player.status.max_speed_mult /= 0.6
	player.status.acc_mult /= 0.6
