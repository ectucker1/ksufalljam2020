extends Control


func _ready():
	hide()


func _input(_event):
	if Input.is_action_just_pressed("ui_cancel"):
		visible = !visible


func _on_Pause_visibility_changed():
	if visible:
		get_tree().paused = true
	else:
		get_tree().paused = false


func _on_Continue_pressed():
	hide()


func _on_Quit_pressed():
	get_tree().quit()
