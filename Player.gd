extends KinematicBody2D

const SPEED = 4500

onready var gift_count = get_tree().get_current_scene().get_node("Gifts").get_child_count()
onready var status = $CanvasLayer/Status
onready var exit = get_tree().get_current_scene().get_node("Exit")
var gifts_picked = 0
var found = false
var win = false
var exiting = false

export (PackedScene) var next_scene
export var soundtrack = true

func _ready():
	status.text = "Collect all gifts: " + str(gifts_picked) + "/" + str(gift_count)
	$ExitArrow.visible = false
	if soundtrack:
		$AudioStreamPlayer.play()

func _process(delta):
	if Input.is_action_just_released("quit"):
		get_tree().quit()
	if Input.is_action_pressed("reset"):
		get_tree().reload_current_scene()
	if Input.is_action_just_released("fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen
	if Input.is_action_just_pressed("skip_level"):
		$NextSceneTimer.start()
		status.text = "Skipping level..."
		found = true

func _physics_process(delta):
	var velocity = Vector2()
	
	if win:
		$AnimatedSprite.play("win")
		return
	
	if found:
		$AnimatedSprite.play("idle")
		return
	
	if exiting:
		$ExitArrow.rotation = get_angle_to(exit.global_position)
	
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	elif Input.is_action_pressed("move_down"):
		velocity.y += 1
	
	move_and_slide(velocity.normalized() * SPEED * delta)
	
	if velocity == Vector2():
		$AnimatedSprite.play("idle")
	else:
		$AnimatedSprite.play("down")

# Switch to _on_Any_playerfound
func _on_Elf_playerfound():
	if $ResetTimer.is_stopped():
		$ResetTimer.start()
		found = true

func _on_Gift_giftpicked():
	gifts_picked += 1
	if gifts_picked < gift_count:
		status.text = "Collect all gifts: " + str(gifts_picked) + "/" + str(gift_count)
	else:
		status.text = "Find the exit!"
		$ExitArrow.visible = true
		exiting = true

func _on_ResetTimer_timeout():
	get_tree().reload_current_scene()

func _on_Exit_body_entered(body):
	if body.name == "Player" and gifts_picked >= gift_count:
		# $CanvasLayer/YOUWIN.visible = true
		$NextSceneTimer.start()
		status.text = ""
		win = true

func _on_Any_playerfound():
	if $ResetTimer.is_stopped():
		$ResetTimer.start()
		found = true

func _on_NextSceneTimer_timeout():
	if next_scene:
		get_tree().change_scene_to(next_scene)
