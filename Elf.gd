extends KinematicBody2D

const SPEED = 50
var follow

var facing = 0.0
var space_state
var check_for_player = false
var scared = false

onready var player = get_tree().get_current_scene().get_node("Player")

signal playerfound

func _ready():
	space_state = get_world_2d().direct_space_state
	if get_parent() is PathFollow2D:
		follow = get_parent()

func _physics_process(delta):
	if scared:
		return
	
	# Verify if can see the player
	if check_for_player:
		var result = space_state.intersect_ray(global_position, player.global_position, [self])
		if result.collider.name == "Player":
			$AnimatedSprite.play("scream")
			scared = true
			emit_signal("playerfound")
			return
	
	var initial = global_position
	
	# Do path
	if follow:
		follow.set_offset(follow.get_offset() + SPEED * delta)
	
	# Rotate view cone
	facing = global_position.angle_to_point(initial)
	$ViewArea.rotation = facing
	
	# Rotate sprite
	var deg_facing = int(rad2deg(facing))
	
	# 135 > || < -135	left
	# -135 < X < -45	up
	# -45 < X < 45		right
	# 45 < X < 135		down
	
	# Left
	if 135 > deg_facing || deg_facing < -135:
		$AnimatedSprite.play("side")
		$AnimatedSprite.flip_h = true
	
	# Up
	if -135 < deg_facing && deg_facing < -45:
		$AnimatedSprite.play("up")
		$AnimatedSprite.flip_h = false
	
	# Right
	if -45 < deg_facing && deg_facing < 45:
		$AnimatedSprite.play("side")
		$AnimatedSprite.flip_h = false
	
	# Down
	if 45 < deg_facing && deg_facing < 135:
		$AnimatedSprite.play("down")
		$AnimatedSprite.flip_h = false

func _on_ViewArea_body_entered(body):
	check_for_player = body.name == "Player"

func _on_ViewArea_body_exited(body):
	if body.name == "Player":
		check_for_player = false
