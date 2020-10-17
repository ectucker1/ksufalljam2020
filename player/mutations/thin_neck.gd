class_name ThinNeckMutation
extends Mutation


func get_name():
	return "Thin Neck"

func on_attached():
	player.status.screenshake_mult *= 5.0

func on_removed():
	player.status.screenshake_mult /= 5.0
