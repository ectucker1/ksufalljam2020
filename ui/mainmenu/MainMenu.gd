extends Control

var rotation_speed := -15


func _ready():
	$AnimationPlayer.play("move_bg")


func _physics_process(delta):
	$wheel.rotation_degrees += rotation_speed * delta


func _on_btnStart_pressed():
	$AnimationPlayer.play("fade_out")


func _on_btnQuit_pressed():
	get_tree().quit()


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "fade_out":
		get_tree().change_scene("res://Arena/Arena.tscn")
