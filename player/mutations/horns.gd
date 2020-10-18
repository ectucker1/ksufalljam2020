class_name HornsMutation
extends Mutation


const COOLDOWN := 0.8
const SPEED_TIME := 0.4
const CHARGE_SPEED := 120.0

var timeout := 0.0
var target_dir := Vector2.ZERO


func get_name():
	return "Goat Horns"

func get_description():
	return "Charge at enemies for 10 damage"

func on_attached():
	player.get_node("Sprites/GoatHorns").visible = true

func on_removed():
	player.get_node("Sprites/GoatHorns").visible = false

func physics_process(delta):
	timeout -= delta
	if timeout > COOLDOWN - SPEED_TIME:
		player.velocity_override = target_dir * CHARGE_SPEED

func on_used():
	if timeout <= 0.0:
		timeout = COOLDOWN
		target_dir = (player.get_global_mouse_position() - player.global_position).normalized()
		player.get_node("Attacks/ChargeArea/AnimationPlayer").play("Attack")
		if GlobalEffects.trauma <= 0.5:
			GlobalEffects.trauma = 0.5
