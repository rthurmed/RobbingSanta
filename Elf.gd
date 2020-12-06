extends KinematicBody2D

const SPEED = 50
var follow

var facing = 0.0

func _ready():
	if get_parent() is PathFollow2D:
		follow = get_parent()

func _physics_process(delta):
	if follow:
		var initial = global_position
		follow.set_offset(follow.get_offset() + SPEED * delta)
		
		facing = global_position.angle_to_point(initial)
		$ViewArea.rotation = facing
		
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
