extends Area2D



func _on_body_entered(body):
	if body is Player:
		Global.game_variables.in_boss = true
		for node in get_parent().get_children():
			if node is Enemy and not node is FinalBoss:
				node.queue_free()
			if node is FinalBoss:
				node.change_state(FinalBoss.States.WAIT)
		Global.play_bgm(Global.bgm2)
		queue_free()
