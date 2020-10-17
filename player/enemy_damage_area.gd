extends Area2D


export var damage: int
export var knockback_magnitude: float

func _ready():
	connect("body_entered", self, "on_body_entered")

func on_body_entered(body):
	if body.is_in_group("enemies"):
		# Hurt the enemy
		body.take_damage(damage * GlobalConsts.player.status.dealt_damage_mult)
		body.knockback_velocity = (body.global_position - global_position).normalized() * knockback_magnitude
		# Alert listeners that player did damage
		for player in get_tree().get_nodes_in_group("players"):
			player.emit_signal("damage_dealt", damage)
