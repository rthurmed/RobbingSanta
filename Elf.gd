extends Area2D

const SPEED = 50
var follow

# Angle to look at when dont have a follow path
export var facing_at = 0.0

var facing = 0.0
var space_state
var check_for_player = false
var scared = false

onready var player = get_tree().get_current_scene().get_node("Player")

signal playerfound

func _ready():
	space_state = get_world_2d().direct_space_state
	facing = deg2rad(facing_at)
	if get_parent() is PathFollow2D:
		follow = get_parent()

func _physics_process(delta):
	if scared:
		return
	
	# Verify if can see the player
	if check_for_player:
		var result = space_state.intersect_ray(global_position, player.global_position, [self])
		if result.collider.name == "Player":
			# Look at the player
			$AnimatedSprite.play("scream")
			$ViewArea.rotation = player.global_position.angle_to_point(global_position)
			scared = true
			# Triggers gameover
			emit_signal("playerfound")
			return
	
	var initial = global_position
	
	# Do path
	if follow:
		follow.set_offset(follow.get_offset() + SPEED * delta)
		facing = global_position.angle_to_point(initial)
	
	# Rotate view cone
	$ViewArea.rotation = facing
	
	# Rotate sprite
	var deg_facing = int(rad2deg(facing))
	
	# 135 > || < -135	left
	# -135 < X < -45	up
	# -45 < X < 45		right
	# 45 < X < 135		down
	
	var animate = "side"
	var flip = false
	
	# Left
	if deg_facing > 135 || deg_facing <= -135:
		flip = true
	# Up
	elif -135 < deg_facing && deg_facing <= -45:
		animate = "up"
	# Right
	elif -45 < deg_facing && deg_facing <= 45:
		flip = false
	# Down
	elif 45 < deg_facing && deg_facing <= 135:
		animate = "down"
	
	if initial == global_position:
		animate += "idle"
	
	if $AnimatedSprite.animation != animate:
		$AnimatedSprite.play(animate)
		$AnimatedSprite.flip_h = flip

func _on_ViewArea_body_entered(body):
	check_for_player = body.name == "Player"

func _on_ViewArea_body_exited(body):
	if body.name == "Player":
		check_for_player = false

func _on_Elf_body_entered(body):
	if body.name == "Player":
		$AnimatedSprite.play("scream")
		$ViewArea.rotation = player.global_position.angle_to_point(global_position)
		scared = true
		emit_signal("playerfound")
