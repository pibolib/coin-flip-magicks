extends Node2D

var text: String = ""
var color: Color = Color.WHITE

func _ready():
	$Label.self_modulate = color
	$Label.text = text
	$AnimationPlayer.play("life")
	await Global.make_timer(1.5).timeout
	queue_free()
