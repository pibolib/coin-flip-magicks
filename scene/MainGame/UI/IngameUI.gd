extends Control

var spell_names: Array[String] = [
	"Mote", "Fireball", "Ice Spikes", "Lightning Beam", "Coin Toss", "Mote II"
]

var spell_descriptions: Array[String] = [
	"Summon a small ball of energy. Free cast.\nA symbol on the card says that it's been the best selling\nspell for over 500 years.",
	"Summon a ball of fire to scorch your foes.\nCosts 1 coin to cast.",
	"Summon several spikes of ice. Costs 1 coin to cast.",
	"Summon a beam of lightning to pierce through foes.\nCosts 2 coins to cast.",
	"Toss some coins, see what happens!\nCosts 25% of your current coin supply to cast.",
	"Summon a ball of energy that can coerce money out of\nenemy coffers. Costs 1 coin to cast. A symbol on the card\nsays that it's a new version of a classic product."
]

const ABILITY_ICON: PackedScene = preload("res://scene/MainGame/UI/AbilityIcon.tscn")

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
	$Shop.visible = get_tree().paused and Global.game_variables.shop_unlocked
	for i in %CardContainer.get_children().size():
		if Global.game_variables.spells.has(i):
			%CardContainer.get_children()[i].modulate = Color(1,1,1,0.5)
	if $AbilityContainer.get_children().size() != Global.game_variables.spells.size():
		var new_icon = ABILITY_ICON.instantiate()
		new_icon.index = $AbilityContainer.get_children().size()
		$AbilityContainer.add_child(new_icon)
	if get_tree().paused:
		%Message.text = "- game paused (press ESC to resume) -"
	else:
		%Message.text = Global.current_message

func show_desc():
	$AnimationPlayer.stop()
	$Description.text = Global.SPELL_DESCRIPTIONS[Global.get_current_spell()]
	$AnimationPlayer.play("HideDescription")


func _on_mote_card_mouse_entered():
	$Shop/Description.text = spell_names[0]
	if Global.game_variables.spells.has(0):
		$Shop/Description.text += "\n(SOLD)"
	else:
		$Shop/Description.text += "\n(5 coins, click to purchase)"
	$Shop/Description.text += "\n%s" % spell_descriptions[0]


func _on_fireball_card_mouse_entered():
	$Shop/Description.text = spell_names[1]
	if Global.game_variables.spells.has(1):
		$Shop/Description.text += "\n(SOLD)"
	else:
		$Shop/Description.text += "\n(25 coins, click to purchase)"
	$Shop/Description.text += "\n%s" % spell_descriptions[1]

func _on_ice_spikes_card_mouse_entered():
	$Shop/Description.text = spell_names[2]
	if Global.game_variables.spells.has(2):
		$Shop/Description.text += "\n(SOLD)"
	else:
		$Shop/Description.text += "\n(50 coins, click to purchase)"
	$Shop/Description.text += "\n%s" % spell_descriptions[2]


func _on_lightning_beam_card_mouse_entered():
	$Shop/Description.text = spell_names[3]
	if Global.game_variables.spells.has(3):
		$Shop/Description.text += "\n(SOLD)"
	else:
		$Shop/Description.text += "\n(75 coins, click to purchase)"
	$Shop/Description.text += "\n%s" % spell_descriptions[3]


func _on_coin_toss_card_mouse_entered():
	$Shop/Description.text = spell_names[4]
	if Global.game_variables.spells.has(4):
		$Shop/Description.text += "\n(SOLD)"
	else:
		$Shop/Description.text += "\n(100 coins, click to purchase)"
	$Shop/Description.text += "\n%s" % spell_descriptions[4]

func _on_mote_2_card_mouse_entered():
	$Shop/Description.text = spell_names[5]
	if Global.game_variables.spells.has(5):
		$Shop/Description.text += "\n(SOLD)"
	else:
		$Shop/Description.text += "\n(50 coins, click to purchase)"
	$Shop/Description.text += "\n%s" % spell_descriptions[5]


func _on_mote_card_gui_input(event):
	if event is InputEventMouseButton:
		if event.pressed and !Global.game_variables.spells.has(0):
			Global.buy_spell(0)


func _on_fireball_card_gui_input(event):
	if event is InputEventMouseButton:
		if event.pressed and !Global.game_variables.spells.has(1):
			Global.buy_spell(1)


func _on_ice_spikes_card_gui_input(event):
	if event is InputEventMouseButton:
		if event.pressed and !Global.game_variables.spells.has(2):
			Global.buy_spell(2)


func _on_lightning_beam_card_gui_input(event):
	if event is InputEventMouseButton:
		if event.pressed and !Global.game_variables.spells.has(3):
			Global.buy_spell(3)


func _on_coin_toss_card_gui_input(event):
	if event is InputEventMouseButton:
		if event.pressed and !Global.game_variables.spells.has(4):
			Global.buy_spell(4)

func _on_mote_2_card_gui_input(event):
	if event is InputEventMouseButton:
		if event.pressed and !Global.game_variables.spells.has(5):
			Global.buy_spell(5)
