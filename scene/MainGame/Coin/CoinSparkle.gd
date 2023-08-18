extends GPUParticles2D
class_name CoinSparkle

func _ready():
	emitting = true
	var timer := get_tree().create_timer(1)
	await timer.timeout
	queue_free()
