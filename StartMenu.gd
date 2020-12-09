extends Control

func _process(delta):
	if Input.is_action_just_released("quit"):
		get_tree().quit()

func _on_PlayButton_pressed():
	get_tree().change_scene("res://Main.tscn")
