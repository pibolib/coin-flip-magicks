extends Area2D

const FIREBALL_EXPLOSION := preload("res://scene/MainGame/Player/PlayerAttacks/FireballExplosion.tscn")
const FIREBALL_EXPLOSION_BLUE := preload("res://scene/MainGame/Player/PlayerAttacks/FireballExplosionBlue.tscn")

var z: float = -8
var velocity := Vector2.ZERO
var speed: float = 260
var angle: float = 0
var buff: bool = false

func _ready():
	if buff:
		$Sprite.region_rect.position = Vector2(17, 17)
	$Sprite.rotation = angle
	velocity = Vector2.from_angle(angle) * speed

func _process(delta):
	$Sprite.position.y = z-4
	position += velocity * delta
	$Sprite.rotation += delta * 32

func _on_area_entered(area):
	if area is Enemy:
		if buff:
			area.take_damage(2)
		else:
			area.take_damage(1)
	explode()
	queue_free()

func _on_body_entered(_body):
	explode()
	queue_free()

func explode():
	var new_explosion
	if buff:
		new_explosion = FIREBALL_EXPLOSION_BLUE.instantiate()
	else:
		new_explosion = FIREBALL_EXPLOSION.instantiate()
	new_explosion.position = $Sprite.global_position
	add_sibling(new_explosion)
