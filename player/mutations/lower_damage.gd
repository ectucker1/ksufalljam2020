class_name LowerDamageMutation
extends Mutation


func get_name():
	return "Calcium Deficiency"

func on_attached():
	player.status.dealt_damage_mult *= 0.5

func on_removed():
	player.status.dealt_damage_mult /= 0.5
