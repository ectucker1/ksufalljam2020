class_name WheelsMutation
extends Mutation


func get_name():
	return "Grow Tires"

func get_description():
	return "Move in tank drive"

func on_attached():
	player.status.tank_drive = true
	player.get_node("Treads").visible = true

func on_removed():
	player.status.tank_drive = false
	player.get_node("Treads").visible = false
