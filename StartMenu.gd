extends Control

func _process(delta):
	if Input.is_action_just_released("quit"):
		get_tree().quit()
	if Input.is_action_just_released("fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen

func _on_PlayButton_pressed():
		get_tree().change_scene("res://level/Level1.tscn")
