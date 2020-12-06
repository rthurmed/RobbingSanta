extends KinematicBody2D

const SPEED = 50
var follow

func _ready():
	if get_parent() is PathFollow2D:
		follow = get_parent()

func _physics_process(delta):
	if follow:
		follow.set_offset(follow.get_offset() + SPEED * delta)
