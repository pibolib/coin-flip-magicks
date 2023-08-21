extends Area2D

const MOTE_EXPLOSION = preload("res://scene/MainGame/Player/PlayerAttacks/MoteExplosion.tscn")

var z: float = -8
var velocity := Vector2.ZERO
var speed: float = 120
var angle: float = 0
var buff: bool = false

func _ready():
	$Bullet.play()
	$Sprite.rotation = angle
	velocity = Vector2.from_angle(angle) * speed

func _process(delta):
	$Sprite.position.y = z-4
	position += velocity * delta
	$Sprite.rotation += delta * 8

func _on_body_entered(body):
	if body is Player:
		body.take_damage()
	explode()
	queue_free()

func explode():
	var new_explosion = MOTE_EXPLOSION.instantiate()
	new_explosion.position = $Sprite.global_position
	add_sibling(new_explosion)
