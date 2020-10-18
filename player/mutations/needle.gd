class_name NeedleMutation
extends Mutation


const COOLDOWN := 0.7
const BULLET_SPEED := 150.0

var timeout := 0.0

var bullet_scene = preload("res://player/mutations/needle.tscn")


func get_name():
	return "Porcupine Quills"

func get_description():
	return "Shoot 8 needles for 2 damage each"

func physics_process(delta):
	timeout -= delta

func on_used():
	if timeout <= 0.0:
		timeout = COOLDOWN
		for i in range(0, 8):
			var angle = TAU / 8 * i
			var bullet = bullet_scene.instance()
			var direction = Vector2(cos(angle), sin(angle))
			player.get_parent().add_child(bullet)
			bullet.global_position = player.global_position + direction * 8.0
			bullet.velocity = direction * BULLET_SPEED
		player.get_node("AudioNeedles").play(0)
