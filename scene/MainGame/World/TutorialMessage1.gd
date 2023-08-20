extends Area2D

func _on_body_entered(body):
	if body is Player:
		Global.current_message = "Left click to attack. Try to defeat this totem here."
