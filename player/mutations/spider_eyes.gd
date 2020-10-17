class_name SpiderEyesMutation
extends Mutation


func get_name():
	return "Spider Eyes"

func on_attached():
	GlobalEffects.find_node("SpiderEyes").visible = true

func on_removed():
	GlobalEffects.find_node("SpiderEyes").visible = false
