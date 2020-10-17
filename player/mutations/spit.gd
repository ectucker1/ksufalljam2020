class_name SpitMutation
extends Mutation


const COOLDOWN := 0.8
const BULLET_SPEED := 100.0

var timeout := 0.0

var bullet_scene = preload("res://player/mutations/spit.tscn")


func get_name():
	return "Acid Spit"

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
