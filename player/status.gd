class_name PlayerStatus
extends Node


# Hold a reference to the attached player
var player

# Define all variables needed to represent status effects
var health := 50 setget set_health

var max_speed_mult := 1.0
var acc_mult := 1.0


func set_health(value):
	var result = clamp(value, 0, 100)
	var diff = result - health
	health = result
	player.emit_signal("hurt", diff)
	if health == 0:
		kill()

func kill():
	player.visible = false

# Reset the values of all status parameters
func reset():
	health = 100
