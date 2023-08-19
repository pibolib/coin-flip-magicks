extends Node2D

const ICE_SPIKE := preload("res://scene/MainGame/Player/PlayerAttacks/IceSpike.tscn")

var angle: float = 0
var buff: bool = false

func _ready():
	if buff:
		for i in 3:
			var ice_spike = ICE_SPIKE.instantiate()
			ice_spike.position = position + Vector2.from_angle(angle+PI/2) * 6 * (i-1)
			ice_spike.angle = angle
			ice_spike.wait = 0.5 + 0.1*i
			add_sibling(ice_spike)
	else:
		for i in 3:
			var ice_spike = ICE_SPIKE.instantiate()
			ice_spike.position = position + Vector2.from_angle(angle+PI/2) * 8 * (i-1)
			ice_spike.angle = angle-PI/20 + (PI/20)*i
			ice_spike.wait = 0.5 + 0.2*i
			add_sibling(ice_spike)
	queue_free()
