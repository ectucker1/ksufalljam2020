class_name PlayerStatus
extends Node


# Hold a reference to the attached player
var player

# Define all variables needed to represent status effects
var health := 100 setget set_health

var max_speed_mult := 1.0
var acc_mult := 1.0

var taken_damage_mult := 1.0

var dealt_damage_mult := 1.0

var screenshake_mult := 1.0

var tank_drive := false


func set_health(value):
	var result = clamp(value, 0, 100)
	var diff = result - health
	if diff < 0:
		health = health + diff * taken_damage_mult
		player.emit_signal("hurt", diff * taken_damage_mult)
	else:
		health = result
	health = clamp(health, 0, 100)
	if health == 0:
		kill()

func kill():
	player.visible = false

# Reset the values of all status parameters
func reset():
	health = 100
