class_name VampirismMutation
extends Mutation


const PERCENT_HEALED := 0.1


func get_name():
	return "Vampirism"

func get_description():
	return "Heal 10% of damage dealt"

func on_damage_dealt(amount):
	player.status.health += amount * PERCENT_HEALED
