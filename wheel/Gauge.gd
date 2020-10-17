extends Node2D

var increasing := false
var gauge_amount := 0.0  # 0 to 1
var gauge_fill_speed := 1

signal gauge_released(amount)


func _ready():
	clear()


func _physics_process(delta):
	if increasing:
		gauge_amount = clamp(gauge_amount + gauge_fill_speed * delta, 0, 1)
		# Move the second point in the line to increase the meter
		$LineMeter.points[1].x = 40 * gauge_amount


func clear():
	gauge_amount = 0
	$LineMeter.points[1].x = 0


func _on_Button_button_down():
	increasing = true


func _on_Button_button_up():
	$Button.disabled = true
	increasing = false
	emit_signal("gauge_released", gauge_amount)
