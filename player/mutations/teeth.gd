class_name SharpTeethMutation
extends Mutation


func get_name():
	return "Sharp Teeth"

func on_attached():
	player.status.dealt_damage_mult *= 2.0

func on_removed():
	player.status.dealt_damage_mult /= 2.0
