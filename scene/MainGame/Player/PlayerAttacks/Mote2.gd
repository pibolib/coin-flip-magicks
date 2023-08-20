extends Area2D

const MOTE_EXPLOSION = preload("res://scene/MainGame/Player/PlayerAttacks/MoteExplosion.tscn")

var z: float = -8
var velocity := Vector2.ZERO
var speed: float = 200
var angle: float = 0
var buff: bool = false

func _ready():
	$Sprite.rotation = angle
	velocity = Vector2.from_angle(angle) * speed

func _process(delta):
	$Sprite.position.y = z-4
	position += velocity * delta

func _on_area_entered(area):
	if area is Enemy:
		if buff:
			for i in 3:
				var coin = Global.instantiate_coin()
				coin.position = position
				call_deferred("add_sibling", coin)
		area.take_damage(1)
		Global.camera_shake += 1
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
