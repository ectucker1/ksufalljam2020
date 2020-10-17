extends Area2D


export var damage: int
var velocity := Vector2.ZERO

func _ready():
	connect("body_entered", self, "on_body_entered")

func _physics_process(delta):
	position += velocity * delta

func on_body_entered(body):
	if body.is_in_group("enemies"):
		# Hurt the enemy
		body.take_damage(damage)
		# Alert listeners that player did damage
		for player in get_tree().get_nodes_in_group("players"):
			player.emit_signal("damage_dealt", damage)
	if not body.is_in_group("players"):
		queue_free()
