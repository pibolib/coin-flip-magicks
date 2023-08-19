extends TextureRect

@export var index: int = 0
var ability: int = 0

func _ready():
	ability = Global.game_variables.spells[index]
	texture.region.position = Vector2(16*ability, 0)
	Global.connect("_on_ui_update", ui_update)
	$KBIndicator.text = "%d" % (index+1)

func _process(_delta):
	if Global.game_variables.spell_cooldown[index] > 10:
		$Cooldown.text = "%d" % Global.game_variables.spell_cooldown[index]
	elif Global.game_variables.spell_cooldown[index] > 0:
		$Cooldown.text = "%0.1f" % Global.game_variables.spell_cooldown[index]

func ui_update():
	$Selected.visible = Global.game_variables.selected_spell == index
	$KBIndicator.visible = !$Selected.visible and !$Cooldown.visible
	if Global.game_variables.spell_cooldown[index] > 0 or Global.game_variables.coin < Global.SPELL_COSTS[ability]:
		$Selected.region_rect.position = Vector2(32, 16)
		self_modulate = Color(1, 1, 1, 0.8)
		$KBIndicator.modulate = Color.RED
	else:
		$Selected.region_rect.position = Vector2(16, 16)
		self_modulate = Color.WHITE
		$KBIndicator.modulate = Color.WHITE
	$Cooldown.visible = Global.game_variables.spell_cooldown[index] > 0
		
