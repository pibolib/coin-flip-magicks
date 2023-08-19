extends Node

signal _on_ui_update
signal _on_scroll

const GAME_DEFAULT: Dictionary = {
	spells = [0, 1],
	spell_cooldown = [0, 0],
	selected_spell = 0,
	hp = 3,
	coin = 0,
	player_position = Vector2(0,0)
}

var time: float = 0

var game_variables: Dictionary = {
	spells = [0, 1, 2, 3],
	spell_cooldown = [0, 0, 0, 0],
	selected_spell = 0,
	hp = 3,
	coin = 0,
	player_position = Vector2(0,0)
}

const SPELL_DESCRIPTIONS: Array[String] = [
	"Mote: 1 damage, free",
	"Fireball: 1 damage AOE, 1 coin\nHeads -> stronger explosion",
	"Ice Spikes: 1x3 damage, 1 coin\nHeads -> concentrated strike",
	"Lightning Beam: 1-??? damage, 2 coins\nHeads -> critical hit",
	"Coin Toss: ??? damage, 25% current coins",
	"Mote II: 1 damage, 1 coin\nHeads -> coins drop"
]

const SPELL_PRELOADS: Array[PackedScene] = [
	preload("res://scene/MainGame/Player/PlayerAttacks/Mote.tscn"),
	preload("res://scene/MainGame/Player/PlayerAttacks/Fireball.tscn"),
	preload("res://scene/MainGame/Player/PlayerAttacks/IceSpikeSpawner.tscn"),
	preload("res://scene/MainGame/Player/PlayerAttacks/LightningBeam.tscn")
]

const SPELL_COOLDOWNS: Array[float] = [
	2, 3, 5, 10, 30, 10
]

const SPELL_COSTS: Array[int] = [
	0, 1, 1, 2, 0, 1
]

func _ready():
	emit_signal("_on_ui_update")

func _process(delta):
	emit_signal("_on_ui_update")
	time += delta
	for index in game_variables.spell_cooldown.size():
		if game_variables.spell_cooldown[index] >= 0:
			game_variables.spell_cooldown[index] -= delta

func get_current_spell_cooldown() -> float:
	return game_variables.spell_cooldown[game_variables.selected_spell]

func set_current_spell_cooldown(value: float) -> void:
	game_variables.spell_cooldown[game_variables.selected_spell] = value
	for index in game_variables.spell_cooldown.size():
		game_variables.spell_cooldown[index] = max(0.5, game_variables.spell_cooldown[index])

func set_selected(value: int) -> void:
	if value <= game_variables.spells.size():
		game_variables.selected_spell = value-1
		emit_signal("_on_scroll")

func scroll_selected(mod: int) -> void:
	game_variables.selected_spell = wrap(game_variables.selected_spell + mod, 0, game_variables.spells.size())
	emit_signal("_on_scroll")

func get_current_spell() -> int:
	return game_variables.spells[game_variables.selected_spell]

func make_timer(len: float) -> SceneTreeTimer:
	var new_timer = get_tree().create_timer(len)
	return new_timer

func instantiate_spell(spell: int) -> Node:
	return SPELL_PRELOADS[spell].instantiate()
