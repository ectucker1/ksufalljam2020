class_name SpiderEyesMutation
extends Mutation


func get_name():
	return "Spider Eyes"

func get_description():
	return "See the world differently"

func on_attached():
	GlobalEffects.find_node("SpiderEyes").visible = true

func on_removed():
	GlobalEffects.find_node("SpiderEyes").visible = false
