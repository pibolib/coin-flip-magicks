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
		for a in $Actual.get_overlapping_areas():
			if a is Enemy:
				if buff:
					a.take_damage(2)
				else:
					a.take_damage(1)
	explode()
	queue_free()

func _on_body_entered(_body):
	for a in $Actual.get_overlapping_areas():
		if a is Enemy:
			if buff:
				a.take_damage(2)
			else:
				a.take_damage(1)
	if Global.distance_to_player(position) > 16:
		explode()
		queue_free()

func explode():
	var new_explosion
	if buff:
		Global.camera_shake += 2
		new_explosion = FIREBALL_EXPLOSION_BLUE.instantiate()
	else:
		Global.camera_shake += 1
		new_explosion = FIREBALL_EXPLOSION.instantiate()
	new_explosion.position = $Sprite.global_position
	add_sibling(new_explosion)
