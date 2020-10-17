extends Node2D

var spinning := false
var min_speed := 10
var max_speed := 50


func _ready():
	randomize()


func _physics_process(delta):
	if spinning and abs($Wheel.angular_velocity) < 0.1:
		spinning = false
		$Wheel.angular_velocity = 0
		# TODO: emit signal or something
		# We can decide on which type of mutation to give based on the color landed
		print($Ray.get_collider().name)
		
		$Gauge.clear()


func spin_wheel(speed = 70):
	$Wheel.angular_velocity = -(speed + randf() * 2)  # randomize slightly
	spinning = true


func _on_Gauge_gauge_released(amount):
	spin_wheel((max_speed - min_speed) * amount + min_speed)
