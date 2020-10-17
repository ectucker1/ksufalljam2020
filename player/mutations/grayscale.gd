class_name GrayscaleMutation
extends Mutation


func get_name():
	return "Void Eyes"

func on_attached():
	GlobalEffects.find_node("Grayscale").visible = true

func on_removed():
	GlobalEffects.find_node("Grayscale").visible = false
