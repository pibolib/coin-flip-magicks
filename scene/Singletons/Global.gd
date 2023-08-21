extends Node

signal _on_ui_update
signal _on_scroll

const GAME_DEFAULT: Dictionary = {
	spells = [0, 1],
	spell_cooldown = [0, 0],
	selected_spell = 0,
	hp = 3,
	coin = 0,
	player_position = Vector2(0,0),
	shop_unlocked = false,
	coins_obtained = 0,
	coins_threshold = 60,
	tutorial_enemies_killed = 0,
	in_boss = false,
	win = false,
}

var time: float = 0
var camera_shake: float = 0

var game_variables: Dictionary = {
	spells = [0, 1],
	spell_cooldown = [0, 0],
	selected_spell = 0,
	hp = 3,
	coin = 0,
	player_position = Vector2(0,0),
	shop_unlocked = true,
	coins_obtained = 0,
	coins_threshold = 60,
	tutorial_enemies_killed = 0,
	in_boss = false,
	win = false,
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
	preload("res://scene/MainGame/Player/PlayerAttacks/LightningBeam.tscn"),
	preload("res://scene/MainGame/Player/PlayerAttacks/ProjCoin.tscn"),
	preload("res://scene/MainGame/Player/PlayerAttacks/Mote2.tscn")
]

const COIN := preload("res://scene/MainGame/Coin/Coin.tscn")
const TEXT := preload("res://scene/MainGame/UI/TextPopup.tscn")

var current_message = "Use WASD to move around."

var bgm1 = preload("res://asset/bgm/bgm1.ogg")
var bgm2 = preload("res://asset/bgm/bgm2.ogg")

var current_bgm: AudioStreamOggVorbis = preload("res://asset/bgm/bgm1.ogg")

const SPELL_COOLDOWNS: Array[float] = [
	2, 3, 5, 10, 30, 10
]

const SPELL_COSTS: Array[int] = [
	0, 1, 1, 2, 0, 1
]

const SPELL_BUY_COSTS: Array[int] = [
	5, 25, 50, 75, 100, 50
]

func _ready():
	emit_signal("_on_ui_update")
	play_bgm(current_bgm)

func _process(delta):
	if Input.is_action_just_pressed("pause"):
		if game_variables.hp <= 0 or game_variables.win:
			play_bgm(bgm1)
			get_tree().reload_current_scene()
			game_variables = GAME_DEFAULT.duplicate(true)
			current_message = "Use WASD to move around."
		else:
			get_tree().paused = !get_tree().paused
	emit_signal("_on_ui_update")
	time += delta
	if !get_tree().paused:
		for index in game_variables.spell_cooldown.size():
			if game_variables.spell_cooldown[index] >= 0:
				game_variables.spell_cooldown[index] -= delta
	if game_variables.coins_obtained >= game_variables.coins_threshold:
		current_message = "%d coins obtained! +1 life" % game_variables.coins_threshold
		increase_lives()
		game_variables.coins_threshold += 60
	if game_variables.tutorial_enemies_killed == 1:
		game_variables.tutorial_enemies_killed += 1
		current_message = "When you defeat enemies, they drop coins."
	elif game_variables.tutorial_enemies_killed == 5:
		game_variables.tutorial_enemies_killed += 1
		current_message = "Nice work! When you use spells, it costs a certain number of coins to do so. Make sure you have enough coins to use a spell."
	if game_variables.win:
		current_message = "You win! Thanks for playing! Press ESC to return to title"
	if game_variables.hp <= 0:
		current_message = "Game over! Press ESC to return to title"

func _physics_process(delta):
	if camera_shake >= 0.5:
		camera_shake -= delta * 8

func increase_lives() -> void:
	game_variables.hp += 1
	await make_timer(2).timeout
	if current_message == "%d coins obtained! +1 life" % (game_variables.coins_threshold-60):
		current_message = ""

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

func make_timer(length: float) -> SceneTreeTimer:
	var new_timer = get_tree().create_timer(length)
	return new_timer

func instantiate_spell(spell: int) -> Node:
	return SPELL_PRELOADS[spell].instantiate()

func distance_to_player(pos: Vector2) -> float:
	return pos.distance_to(game_variables.player_position)

func instantiate_coin() -> Node:
	return COIN.instantiate()

func instantiate_text(text: String, color: Color = Color.WHITE) -> Node:
	var new_text := TEXT.instantiate()
	new_text.text = text
	new_text.color = color
	return new_text

func buy_spell(spell: int) -> void:
	if game_variables.coin >= SPELL_BUY_COSTS[spell]:
		game_variables.spells.append(spell)
		game_variables.coin -= SPELL_BUY_COSTS[spell]
		game_variables.spell_cooldown.append(0)
		$Buy.play()
	else:
		$CannotBuy.play()

func play_bgm(bgm: AudioStreamOggVorbis) -> void:
	if $BGM.playing:
		var tween := get_tree().create_tween()
		tween.tween_property($BGM, "volume_db", -80, 2)
		await tween.finished
		$BGM.stream = bgm
		$BGM.volume_db = 0
		$BGM.play()
	else:
		$BGM.stream = bgm
		$BGM.volume_db = 0
		$BGM.play()
