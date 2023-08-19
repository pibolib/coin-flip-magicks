extends GPUParticles2D

func _ready():
	emitting = true
	await Global.make_timer(1.2).timeout
	queue_free()
