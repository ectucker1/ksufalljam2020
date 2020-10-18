class_name SpeedUpMutation
extends Mutation


func get_name():
	return "Cheeta's Heart"

func get_description():
	return "Move faster"

func on_attached():
	player.status.max_speed_mult *= 1.3
	player.status.acc_mult *= 1.3

func on_removed():
	player.status.max_speed_mult /= 1.3
	player.status.acc_mult /= 1.3
