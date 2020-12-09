extends Area2D

signal playerfound

const SPEED = 400

var follow
var running = true

func _ready():
	if get_parent() is PathFollow2D:
		follow = get_parent()

func _physics_process(delta):
	# Do path
	if follow and running:
		follow.set_offset(follow.get_offset() + SPEED * delta)

func _on_Elf_playerfound():
	emit_signal("playerfound")
	running = false

func _on_Train_body_entered(body):
	if body.name == "Player":
		emit_signal("playerfound")
		running = false
