extends KinematicBody2D

const SPEED = 100

onready var gift_count = get_tree().get_current_scene().get_node("Gifts").get_child_count()
onready var status = $CanvasLayer/Status
var gifts_picked = 0
var found = false

func _process(delta):
	if Input.is_action_just_released("quit"):
		get_tree().quit()
	if Input.is_action_pressed("reset"):
		get_tree().reload_current_scene()

func _physics_process(delta):
	var velocity = Vector2()
	
	status.text = str(gifts_picked) + "/" + str(gift_count)
	
	if found:
		$AnimatedSprite.play("idle")
		return
	
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	elif Input.is_action_pressed("move_down"):
		velocity.y += 1
	
	move_and_collide(velocity.normalized() * SPEED * delta)
	
	if velocity == Vector2():
		$AnimatedSprite.play("idle")
	else:
		$AnimatedSprite.play("down")

func _on_Elf_playerfound():
	$ResetTimer.start()
	found = true

func _on_Gift_giftpicked():
	gifts_picked += 1

func _on_Building_body_exited(body):
	if body.name == "Player" and gifts_picked >= gift_count:
		$CanvasLayer/YOUWIN.visible = true
		found = true

func _on_ResetTimer_timeout():
	get_tree().reload_current_scene()
