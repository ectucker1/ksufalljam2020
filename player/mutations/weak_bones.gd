class_name WeakBonesMutation
extends Mutation


func get_name():
	return "WeakBones"

func on_attached():
	player.status.taken_damage_mult *= 2.0

func on_removed():
	player.status.taken_damage_mult /= 2.0
