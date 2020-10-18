extends Area2D


export var damage: int
export var knockback_magnitude: float
export var rotation_speed: float

var started = false
var time_since_bounce = -INF

var velocity := Vector2.ZERO

func _ready():
	connect("body_entered", self, "on_body_entered")

func _physics_process(delta):
	position += velocity * delta
	if not started:
		look_at(position + velocity)
		started = true
	else:
		rotate(rotation_speed)
	time_since_bounce += delta
	
	# Bones have some chance to escape, so free them up
	if global_position.length_squared() > 2000000:
		queue_free()

func on_body_entered(body):
	if body.is_in_group("enemies"):
		# Hurt the enemy
		body.take_damage(damage * GlobalConsts.player.status.dealt_damage_mult)
		body.knockback_velocity = (body.global_position - global_position).normalized() * knockback_magnitude
		# Alert listeners that player did damage
		for player in get_tree().get_nodes_in_group("players"):
			player.emit_signal("damage_dealt", damage)
	if not body.is_in_group("players"):
		if time_since_bounce < 0.0:
			velocity = -velocity
			time_since_bounce = 0.0
		elif time_since_bounce > 0.5:
			queue_free()
