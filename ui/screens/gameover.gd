extends CanvasLayer


func _ready():
	GlobalConsts.player.connect("killed", self, "show")

func show():
	$AnimationPlayer.play("show")

func hide():
	GlobalSounds.get_node("AnimationPlayer").play("to_wheel")
	$AnimationPlayer.play("hide")

func restart_game():
	GlobalConsts.player.remove_mutations()
	get_tree().change_scene(get_tree().get_current_scene().get_filename())

func _on_PlayAgain_pressed():
	$CenterContainer/VBoxContainer/PlayAgain.disabled = true
	hide()
	GlobalEffects.fade_out()
	GlobalSounds.get_node("ButtonClick").play()

func _on_Quit_pressed():
	get_tree().quit()
