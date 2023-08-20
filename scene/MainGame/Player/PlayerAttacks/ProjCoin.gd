extends Area2D

const MOTE_EXPLOSION = preload("res://scene/MainGame/Player/PlayerAttacks/MoteExplosion.tscn")

var z: float = -8
var velocity := Vector2.ZERO
var speed: float = 400
var angle: float = 0
var buff: bool = false
var damage: int = 0

func _ready():
	$Sprite.rotation = angle
	velocity = Vector2.from_angle(angle) * speed

func _process(delta):
	$Sprite.scale.y = sin(Global.time*4)
	$Sprite.position.y = z-4
	position += velocity * delta

func _on_area_entered(area):
	if area is Enemy:
		area.take_damage(damage)
		Global.camera_shake += 2
	explode()
	queue_free()

func _on_body_entered(_body):
	if Global.distance_to_player(position) > 12:
		explode()
		queue_free()

func explode():
	var new_explosion = MOTE_EXPLOSION.instantiate()
	new_explosion.position = $Sprite.global_position
	add_sibling(new_explosion)
