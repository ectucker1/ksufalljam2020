class_name PlayerStatus
extends Node


# Hold a reference to the attached player
var player

# Define all variables needed to represent status effects
var health := 100 setget set_health


func set_health(value):
	var result = clamp(value, 0, 100)
	var diff = result - health
	health = result
	player.emit_signal("hurt", diff)

# Reset the values of all status parameters
func reset():
	health = 100
