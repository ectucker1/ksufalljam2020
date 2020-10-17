extends Area2D


export var damage: int

func _ready():
	connect("body_entered", self, "on_body_entered")

func on_body_entered(body):
	if body.is_in_group("enemies"):
		# TODO Actually damage enemy
		pass
