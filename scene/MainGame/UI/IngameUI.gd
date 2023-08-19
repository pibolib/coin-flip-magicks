extends Control

func _ready():
	Global.connect("_on_ui_update", ui_update)
	Global.connect("_on_scroll", show_desc)

func ui_update():
	%LifeLabel.text = "x%d" % Global.game_variables.hp
	%CoinLabel.text = "x%d" % Global.game_variables.coin
	if Global.game_variables.hp <= 1:
		%LifeLabel.modulate = Color.RED
	else:
		%LifeLabel.modulate = Color.WHITE

func show_desc():
	$AnimationPlayer.stop()
	$Description.text = Global.SPELL_DESCRIPTIONS[Global.get_current_spell()]
	$AnimationPlayer.play("HideDescription")
