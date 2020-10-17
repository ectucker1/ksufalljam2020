class_name FireMutation
extends Mutation


const RATE := 0.3

var timeout := 0.0

var fire_scene = preload("res://player/mutations/fire.tscn")


func get_name():
	return "Fire Paws"

func physics_process(delta):
	timeout -= delta
	if timeout <= 0.0 and player.velocity != Vector2.ZERO:
		timeout = RATE
		var fire = fire_scene.instance()
		player.get_parent().add_child(fire)
		fire.global_position = player.global_position
