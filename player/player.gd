class_name Player
extends KinematicBody2D


# Movement constants
const BASE_ACC := 128.0
const BASE_MAX_SPEED := 64.0
const STOPPING_FRICTION := 256.0
const TANK_ROT_SPEED := 0.05

# Holds the player's health and other status effects
var status := PlayerStatus.new()

# The mutations the player currently has
var primary_active setget set_primary_active
var secondary_active setget set_secondary_active
var passives := []

# Phyiscs properties
var velocity := Vector2.ZERO
var velocity_override := Vector2.ZERO

var enabled = false
var dead = false

# Signals emitted when various events happen
# These are neccessary for mutations to work
signal hurt(amount)
signal damage_dealt(amount)
signal killed()


# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("players")
	status.player = self
	GlobalConsts.player = self
	
	connect("hurt", self, "hurt_anim")
	
	set_primary_active(BasicAttackMutation.new())
	set_secondary_active(GroundPoundMutation.new())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	enabled = not get_parent().get_node("WheelLayer/Wheel").visible
	if dead:
		enabled = false
	
	if enabled:
		# Call processing method on each mutation
		if primary_active != null:
			primary_active.process(delta)
		if secondary_active != null:
			secondary_active.process(delta)
		for passive in passives:
			passive.process(delta)
		
		$Sprites/RightSprite.visible = false
		$Sprites/LeftSprite.visible = false
		$Sprites/UpSprite.visible = false
		$Sprites/DownSprite.visible = false
		match get_facing():
			GlobalConsts.DIR_RIGHT:
				$Sprites/RightSprite.visible = true
			GlobalConsts.DIR_LEFT:
				$Sprites/LeftSprite.visible = true
			GlobalConsts.DIR_UP:
				$Sprites/UpSprite.visible = true
			GlobalConsts.DIR_DOWN:
				$Sprites/DownSprite.visible = true

# Called at a fixed rate. 'delta' is the elapsed time since the previous call.
func _physics_process(delta):
	if enabled:
		# Get the direction the player wants to move in
		var input_dir = Vector2.ZERO
		input_dir.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
		input_dir.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
		input_dir = input_dir.normalized()
		
		# Apply acceleration if we're holding a direction
		if input_dir != Vector2.ZERO:
			# Normal movement mode
			if not status.tank_drive:
				velocity += BASE_ACC * status.acc_mult * input_dir * delta
			# Tank drive
			else:
				$Treads.rotate(input_dir.x * TANK_ROT_SPEED)
				velocity += Vector2(cos($Treads.rotation), sin($Treads.rotation)) * BASE_ACC * status.acc_mult * delta * -input_dir.y
			# Clamp to max velocity
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
	
	if status.tank_drive:
		input_dir = Vector2(cos($Treads.rotation), sin($Treads.rotation))
	
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
		primary_active.on_removed()
	connect_mutation(mutation)
	primary_active = mutation

# When an active is set, connect relevant signals to it
func set_secondary_active(mutation):
	if secondary_active != null:
		secondary_active.on_removed()
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

func remove_mutations():
	if primary_active != null:
		primary_active.on_removed()
	if secondary_active != null:
		secondary_active.on_removed()
	for passive in passives:
		passive.on_removed()
