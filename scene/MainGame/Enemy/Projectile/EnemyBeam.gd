extends Node2D

var length: float = 1
var buff: bool = false
var angle: float = 0
var rate: float = 100
var active: bool = true

func _ready():
	$Marker2D.rotation = angle
	$Collision.rotation = angle
	$AnimationPlayer.play("life")
	if buff:
		$Marker2D/Line2D.modulate = Color(1,0.6,0.6,1)
	$Beam.play()

func _process(delta):
	if active:
		length += rate * delta
		rate += delta * 350
	$Marker2D.scale.x = length
	$Collision.scale.x = length
	$Ball.global_position = %BallPos.global_position

func _physics_process(_delta):
	$Ball.offset = Vector2(randf_range(-2,2),randf_range(-2,2))
	$Marker2D.position = Vector2(0,-10) + Vector2(randf_range(-0.5,0.5),randf_range(-0.5,0.5))

func _on_collision_body_entered(body):
	if body is Player:
		body.take_damage()
	else:
		Global.camera_shake += 3
		active = false
