extends Area2D

func _on_body_entered(body):
	if body is Player:
		Global.current_message = "Press 2 to switch to your second spell, Fireball. Try to use it on this group of totems to defeat them together."
