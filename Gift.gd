extends Area2D

signal giftpicked

func _on_Gift_body_entered(body):
	if body.name == "Player":
		emit_signal("giftpicked")
		queue_free()
		
