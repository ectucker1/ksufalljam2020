class_name BoomerangMutation
extends Mutation


const COOLDOWN := 1.3
const BULLET_SPEED := 80.0

var timeout := 0.0

var bullet_scene = preload("res://player/mutations/bone.tscn")


func get_name():
	return "Detached Femur"

func get_description():
	return "Throw a bouncing bone for 10 damage"

func physics_process(delta):
	timeout -= delta

func on_used():
	if timeout <= 0.0:
		timeout = COOLDOWN
		var target_dir = (player.get_global_mouse_position() - player.global_position).normalized()
		var bullet = bullet_scene.instance()
		player.get_parent().add_child(bullet)
		bullet.global_position = player.global_position + target_dir * 8.0
		bullet.velocity = target_dir * BULLET_SPEED
		if GlobalEffects.trauma < 0.3:
			GlobalEffects.trauma = 0.3
