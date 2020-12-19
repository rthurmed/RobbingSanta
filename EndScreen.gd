extends Control

func _ready():
	if $"/root/Configs".music:
		$AudioStreamPlayer.play()

func _process(delta):
	if Input.is_action_just_released("quit"):
		get_tree().quit()
	if Input.is_action_just_released("fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen
	if Input.is_action_just_pressed("mute"):
		$AudioStreamPlayer.playing = not $AudioStreamPlayer.playing
		$"/root/Configs".music = $AudioStreamPlayer.playing

func _on_QuitButton_pressed():
	get_tree().quit()
