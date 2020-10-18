extends Node2D

var spinning := false
var min_speed := 10
var max_speed := 50

var available_passives = []
var available_actives = []
var last_primary := false

var player

export var player_path: NodePath


func _ready():
	randomize()
	
	player = get_node(player_path)
	
	available_passives.append(FireMutation.new())
	available_passives.append(GrayscaleMutation.new())
	available_passives.append(LowerDamageMutation.new())
	available_passives.append(SpeedUpMutation.new())
	available_passives.append(SpiderEyesMutation.new())
	available_passives.append(SharpTeethMutation.new())
	available_passives.append(ThinNeckMutation.new())
	available_passives.append(VampirismMutation.new())
	available_passives.append(WeakBonesMutation.new())
	available_passives.append(WheelsMutation.new())
	
	available_actives.append(HornsMutation.new())
	available_actives.append(SpitMutation.new())
	available_actives.append(WarpDriveMutation.new())
	available_actives.append(GroundPoundMutation.new())


func _physics_process(delta):
	if spinning and abs($Wheel.angular_velocity) < 0.1:
		spinning = false
		$Wheel.angular_velocity = 0
		
		if ($Ray.get_collider().name == "Red"):
			add_active()
		else:
			add_passive()
		
		$AudioSpin.stop()
		$Anim.play("show_mutation")


func spin_wheel(speed = 70):
	$Wheel.angular_velocity = -(speed + randf() * 2)  # randomize slightly
	$AudioSpin.play(0)
	spinning = true


func show_screen():
	$Gauge.clear()
	$Anim.play("appear")


func hide_screen():
	$Anim.play("disappear")

func _on_Gauge_gauge_released(amount):
	spin_wheel((max_speed - min_speed) * amount + min_speed)

func add_active():
	var choice = choose_from(available_actives)
	if choice != null:
		if not last_primary:
			player.set_primary_active(choice)
			$MutationDisplay/Layout/MutationBinding.text = "Bound to M1"
		else:
			player.set_secondary_active(choice)
			$MutationDisplay/Layout/MutationBinding.text = "Bound to M2"
		$MutationDisplay/Layout/MutationName.text = choice.get_name()
		$MutationDisplay/Layout/MutationDescription.text = choice.get_description()
		last_primary = not last_primary
	else:
		$MutationDisplay/Layout/MutationName.text = "Nothing"
		$MutationDisplay/Layout/MutationDescription.text = "No Active Mutations Remain"
		$MutationDisplay/Layout/MutationBinding.text = ""

func add_passive():
	var choice = choose_from(available_passives)
	if choice != null:
		player.add_passive(choice)
		$MutationDisplay/Layout/MutationName.text = choice.get_name()
		$MutationDisplay/Layout/MutationDescription.text = choice.get_description()
		$MutationDisplay/Layout/MutationBinding.text = ""
	else:
		$MutationDisplay/Layout/MutationName.text = "Nothing"
		$MutationDisplay/Layout/MutationDescription.text = "No Passive Mutations Remain"
		$MutationDisplay/Layout/MutationBinding.text = ""

func choose_from(array):
	if array.size() == 0:
		return null
	else:
		var choice = array[randi() % array.size()]
		array.erase(choice)
		return choice

func _on_AgainButton_pressed():
	$Gauge/Button.disabled = false
	$Gauge.clear()
	$Anim.play("hide_mutation")

func _on_StartButton_pressed():
	hide_screen()
