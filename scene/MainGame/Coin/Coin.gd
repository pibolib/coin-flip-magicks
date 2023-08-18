extends Area2D

const SPARKLE := preload("res://scene/MainGame/Coin/CoinSparkle.tscn")

var z: float = 0
var zsp: float = 0
var g: float = 150
var velocity := Vector2.ZERO
var time_offset: float = 0

func _ready():
	zsp = randf_range(-100, -150)
	time_offset = randf_range(-1, 1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	zsp += g * delta
	z += zsp * delta
	if z > 0:
		if abs(zsp) < 4:
			zsp = 0
			g = 0
		else:
			zsp = -zsp*0.5
			var sparkle = SPARKLE.instantiate()
			sparkle.position = position
			add_sibling(sparkle)
		z = 0

func _physics_process(delta):
	$Sprite.position.y = z
	$Sprite.scale.x = lerp($Sprite.scale.x, sin(Global.time*2 + time_offset), 0.4)
