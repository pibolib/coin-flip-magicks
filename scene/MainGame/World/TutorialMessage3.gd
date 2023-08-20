extends Area2D

func _on_body_entered(body):
	if body is Player:
		Global.current_message = "From here on out, you're on your own. See what this world has to offer!"
