extends Control


func _ready():
	hide()


func _input(_event):
	if Input.is_action_just_pressed("ui_cancel"):
		visible = !visible


func _on_Pause_visibility_changed():
	if visible:
		get_tree().paused = true
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), -17)
	else:
		get_tree().paused = false
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), -7)


func _on_Continue_pressed():
	hide()


func _on_Quit_pressed():
	get_tree().quit()
