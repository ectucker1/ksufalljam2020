class_name Player
extends KinematicBody2D


# Movement constants
const BASE_ACC := 128.0
const BASE_MAX_SPEED := 64.0
const STOPPING_FRICTION := 256.0

# Holds the player's health and other status effects
var status := PlayerStatus.new()

# The mutations the player currently has
var primary_active setget set_primary_active
var secondary_active setget set_secondary_active
var passives := []

# Phyiscs properties
var velocity := Vector2.ZERO
var velocity_override := Vector2.ZERO

# Signals emitted when various events happen
# These are neccessary for mutations to work
signal hurt(amount)
signal damage_dealt(amount)


# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("players")
	status.player = self
	connect("hurt", self, "hurt_anim")
	
	add_passive(FireMutation.new())

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
	# Get the direction the player wants to move in
	var input_dir = Vector2.ZERO
	input_dir.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_dir.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	input_dir = input_dir.normalized()
	
	# Apply acceleration if we're holding a direction
	if input_dir != Vector2.ZERO:
		velocity += BASE_ACC * status.acc_mult * input_dir * delta
		if velocity.length() > BASE_MAX_SPEED * status.max_speed_mult:
			velocity = velocity.normalized() * BASE_MAX_SPEED * status.max_speed_mult
	else:
		velocity = velocity.normalized() * clamp(velocity.length() - STOPPING_FRICTION * delta, 0.0, INF)
	
	velocity_override = Vector2.ZERO
	
	# Call phyiscs processing method on each mutation
	if primary_active != null:
		primary_active.physics_process(delta)
	if secondary_active != null:
		secondary_active.physics_process(delta)
	for passive in passives:
		passive.physics_process(delta)
	
	if velocity_override != Vector2.ZERO:
		velocity = velocity_override
	
	# Actually apply movement and update velocity if we hit something
	velocity = move_and_slide(velocity, Vector2.ZERO)
	
	# If active keys are held, call their use
	if Input.is_action_pressed("attack_primary"):
		if primary_active != null:
			primary_active.on_used()
	if Input.is_action_pressed("attack_secondary"):
		if secondary_active != null:
			secondary_active.on_used()

func get_facing():
	var input_dir = Vector2.ZERO
	input_dir.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_dir.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	input_dir = input_dir.normalized()
	
	if abs(input_dir.x) >= abs(input_dir.y):
		if input_dir.x >= 0:
			return GlobalConsts.DIR_RIGHT
		else:
			return GlobalConsts.DIR_LEFT
	else:
		if input_dir.y <= 0:
			return GlobalConsts.DIR_UP
		else:
			return GlobalConsts.DIR_DOWN

# Connect relevant signals to the given mutation
func connect_mutation(mutation):
	mutation.player = self
	connect("hurt", mutation, "on_hurt")
	connect("damage_dealt", mutation, "on_damage_dealt")
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

func hurt_anim(amount):
	$AnimationTree["parameters/HurtShot/active"] = true
	if GlobalEffects.trauma < 0.3:
		GlobalEffects.trauma += 0.4
	elif GlobalEffects.trauma < 0.4:
		GlobalEffects.trauma = 0.4
