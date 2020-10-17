class_name BasicAttackMutation
extends Mutation


var COOLDOWN := 0.7

var timeout := 0.0


func get_name():
	return "Basic Attack"

func physics_process(delta):
	timeout -= delta

func on_used():
	if timeout <= 0.0:
		timeout = COOLDOWN
		var animation_choice = ""
		match player.get_facing():
			GlobalConsts.DIR_UP:
				animation_choice = "AttackUp"
			GlobalConsts.DIR_DOWN:
				animation_choice = "AttackDown"
			GlobalConsts.DIR_LEFT:
				animation_choice = "AttackLeft"
			GlobalConsts.DIR_RIGHT:
				animation_choice = "AttackRight"
		player.get_node("Attacks/BasicAttack/AnimationPlayer").play(animation_choice)
