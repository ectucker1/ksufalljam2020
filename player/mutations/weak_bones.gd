class_name WeakBonesMutation
extends Mutation


func get_name():
	return "Weak Bones"

func get_description():
	return "Take double damage"

func on_attached():
	player.status.taken_damage_mult *= 2.0

func on_removed():
	player.status.taken_damage_mult /= 2.0
