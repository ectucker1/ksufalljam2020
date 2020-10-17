class_name Player
extends KinematicBody2D


# Signals emitted when various events happen
# These are neccessary for mutations to work
signal hurt(amount)
signal damage_dealt(amount)


# Holds the player's health and other status effects
var status := PlayerStatus.new()

# The mutations the player currently has
var primary_active setget set_primary_active
var secondary_active setget set_secondary_active
var passives := []


# Called when the node enters the scene tree for the first time.
func _ready():
	primary_active = Mutation.new()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Call processing method on each mutation
	if primary_active != null:
		primary_active.process(delta)
	if secondary_active != null:
		secondary_active.process(delta)
	for passive in passives:
		passive.process(delta)

# Called at a fixed rate. 'delta' is the elapsed time since the previous call.
func _physics_process(delta):
	# Call phyiscs processing method on each mutation
	if primary_active != null:
		primary_active.physics_process(delta)
	if secondary_active != null:
		secondary_active.physics_process(delta)
	for passive in passives:
		passive.physics_process(delta)

# Connect relevant signals to the given mutation
func connect_mutation(mutation):
	mutation.player = self
	connect("hurt", primary_active, "on_hurt")
	connect("damage_dealt", primary_active, "on_damage_dealt")
	mutation.on_attached()

# When an active is set, connect relevant signals to it
func set_primary_active(mutation):
	if primary_active != null:
		primary_active.on_detached()
	connect_mutation(mutation)
	primary_active = mutation

# When an active is set, connect relevant signals to it
func set_secondary_active(mutation):
	if secondary_active != null:
		secondary_active.on_detached()
	connect_mutation(mutation)
	secondary_active = mutation

# When adding a new passive, connect relvant signals
func add_passive(mutation):
	connect_mutation(mutation)
	passives.append(mutation)
