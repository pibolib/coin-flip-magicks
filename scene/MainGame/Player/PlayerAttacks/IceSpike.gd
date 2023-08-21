extends Area2D

const MOTE_EXPLOSION = preload("res://scene/MainGame/Player/PlayerAttacks/MoteExplosion.tscn")

var z: float = -12
var velocity := Vector2.ZERO
var speed: float = 300
var angle: float = 0
var active: bool = false
var wait: float = 0.5

func _ready():
	$Sprite.rotation = angle
	velocity = Vector2.from_angle(angle) * speed
	await Global.make_timer(wait).timeout
	active = true

func _process(delta):
	$Sprite.position.y = z-4
	if active:
		position += velocity * delta

func _on_area_entered(area):
	if area is Enemy:
		area.take_damage(1)
	velocity = Vector2.ZERO
	explode()

func _on_body_entered(_body):
	if Global.distance_to_player(position) > 16:
		velocity = Vector2.ZERO
		explode()

func explode():
	Global.camera_shake += 0.5
	var tween := get_tree().create_tween()
	tween.tween_property(self, "modulate", Color(1,1,1,0), 1.5)
	await Global.make_timer(1.5).timeout
	queue_free()
