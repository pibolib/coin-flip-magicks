extends Node2D

var mode := "Heads"

func _ready():
	$AnimationPlayer.play(mode)
	await $AnimationPlayer.animation_finished
	queue_free()
