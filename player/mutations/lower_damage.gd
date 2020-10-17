class_name LowerDamageMutation
extends Mutation


func get_name():
	return "Calcium Deficiency"

func get_description():
	return "Deal half damage"

func on_attached():
	player.status.dealt_damage_mult *= 0.5

func on_removed():
	player.status.dealt_damage_mult /= 0.5
