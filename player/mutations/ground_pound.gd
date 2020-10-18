class_name GroundPoundMutation
extends Mutation


var COOLDOWN := 0.9

var timeout := 0.0


func get_name():
	return "Monkey Fists"

func get_description():
	return "Pound the ground for 10 AOE damage"

func physics_process(delta):
	timeout -= delta

func on_used():
	if timeout <= 0.0:
		timeout = COOLDOWN
		player.get_node("Attacks/GroundPound/AnimationPlayer").play("Attack")
