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
		player.get_node("Attacks/BasicAttack/HitBox").look_at(player.get_global_mouse_position())
		player.get_node("Attacks/BasicAttack/AnimationPlayer").play("Attack")
