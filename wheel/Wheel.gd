extends Node2D

var spinning := false


func _ready():
	randomize()
	spin_wheel()


func _physics_process(delta):
	if spinning and $Wheel.angular_velocity < 0.1:
		spinning = false
		$Wheel.angular_velocity = 0
		# TODO: emit signal or something
		print($RayCast2D.get_collider().name)


func spin_wheel(speed = 70):
	$Wheel.angular_velocity = speed + randf() * 10
	spinning = true
