extends Area2D

func _on_body_entered(body):
	if body is Player:
		Global.current_message = "Welcome to my shop! Here, you can buy various spells.\n(from here on out, you can press ESC anywhere to purchase spells)"
		Global.game_variables.shop_unlocked = true


func _on_body_exited(body):
	if body is Player and Global.current_message == "Welcome to my shop! Here, you can buy various spells.\n(from here on out, you can press ESC anywhere to purchase spells)":
		Global.current_message = ""
