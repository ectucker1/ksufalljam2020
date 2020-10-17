class_name Mutation
extends Reference


# Each mutation holds a reference to the player
var player


func get_name():
	return "Base Mutation"

# Define all the things a mutation can react to

# Called when a mutation is attached to modify player state
func on_attached():
	pass

# Called when a mutation is detached to remove state changes
func on_removed():
	pass

func process(delta):
	pass

func physics_process(delta):
	pass

func on_hurt(amount):
	pass

func on_damage_dealt(amount):
	pass

# This will be called when an active mutation is used
func on_used():
	pass
