extends CharacterBody2D
class_name Player

const COIN_FLIP_ANIM = preload("res://scene/MainGame/Player/CoinFlipAnim.tscn")
const MOTE_EXPLOSION = preload("res://scene/MainGame/Player/PlayerAttacks/MoteExplosion.tscn")
const COIN = preload("res://scene/MainGame/Coin/Coin.tscn")

var z: float = -8
var flip_sprite := false
var movement_speed: float = 100
var movement_vector := Vector2.ZERO
var aim_angle: float = 0
var invulnerable = false
var shake: float = 0

func _ready():
	$Sprite.play("default")

func _process(_delta):
	if Global.game_variables.hp <= 0 and !invulnerable and visible:
		var explosion = MOTE_EXPLOSION.instantiate()
		explosion.position = position
		add_sibling(explosion)
		visible = false
		$CollisionShape2D.disabled = true
		$PickupRadius/CollisionShape2D.disabled = true
		$Generic.play()
		var coin = COIN.instantiate()
		coin.position = position
		add_sibling(coin)
	if Global.game_variables.hp <= 0:
		shake = 2
		modulate.a = 0.5
	#block dedicated to updating visuals
	if Global.game_variables.in_boss:
		$Camera2D.global_position.x = 3440
		$Camera2D.position_smoothing_enabled = true
	else:
		$Camera2D.position = Vector2.ZERO
		$Camera2D.position_smoothing_enabled = false
	$Sprite.position.y = z
	$Sprite.flip_h = flip_sprite
	aim_angle = position.angle_to_point(get_global_mouse_position())
	
	Global.game_variables.player_position = global_position
	
	movement_vector = Vector2.ZERO
	if Input.is_action_just_pressed("select_up"):
		Global.scroll_selected(-1)
	elif Input.is_action_just_pressed("select_down"):
		Global.scroll_selected(1)
	if Input.is_action_just_pressed("select_1"):
		Global.set_selected(1)
	elif Input.is_action_just_pressed("select_2"):
		Global.set_selected(2)
	elif Input.is_action_just_pressed("select_3"):
		Global.set_selected(3)
	elif Input.is_action_just_pressed("select_4"):
		Global.set_selected(4)
	elif Input.is_action_just_pressed("select_5"):
		Global.set_selected(5)
	elif Input.is_action_just_pressed("select_6"):
		Global.set_selected(6)
	if Input.is_action_just_pressed("fire") and Global.game_variables.hp > 0:
		fire()
	if Input.is_action_pressed("move_left"):
		movement_vector.x = -1
		flip_sprite = true
	elif Input.is_action_pressed("move_right"):
		movement_vector.x = 1
		flip_sprite = false
	if Input.is_action_pressed("move_up"):
		movement_vector.y = -1
	elif Input.is_action_pressed("move_down"):
		movement_vector.y = 1
	if movement_vector != Vector2.ZERO and Global.game_variables.hp > 0:
		velocity = movement_speed * movement_vector.normalized()
	else:
		velocity = Vector2.ZERO
	move_and_slide()

func _physics_process(delta):
	z = lerp(z, -8 + 2*sin(Global.time*8), 0.1)
	$Target.rotation = lerp_angle($Target.rotation, aim_angle, 0.5)
	if shake >= 0.5:
		$Sprite.position.x = randf_range(-shake, shake)
		shake -= delta * 8
	if Global.camera_shake >= 0.5:
		$Camera2D.position.x = randf_range(-Global.camera_shake, Global.camera_shake)
	else:
		$Camera2D.position.x = 0

func fire():
	var spell: int = Global.get_current_spell()
	var buff = randi() % 2
	if Global.get_current_spell_cooldown() <= 0 and Global.game_variables.coin >= Global.SPELL_COSTS[spell]:
		Global.set_current_spell_cooldown(Global.SPELL_COOLDOWNS[spell])
		Global.game_variables.coin -= Global.SPELL_COSTS[spell]
		match spell:
			0:
				$Generic.play()
			1:
				$Fireball.play()
			2:
				$IceSpikes.play()
			3:
				$LightningBeam.play()
			4:
				$Generic.play()
			5:
				$Mote2.play()
		if spell != 0 and spell != 4:
			if buff == 1:
				make_coin_flip("Heads")
			else:
				make_coin_flip("Tails")
			await Global.make_timer(0.5).timeout
		var proj = Global.instantiate_spell(spell)
		if spell == 4:
			proj.damage = floor(Global.game_variables.coin / 4)
			Global.game_variables.coin -= floor(Global.game_variables.coin / 4)
		proj.angle = aim_angle
		proj.buff = buff == 1
		proj.position = position
		add_sibling(proj)

func _on_pickup_radius_area_entered(area):
	Global.game_variables.coin += 1
	Global.game_variables.coins_obtained += 1
	$Coin.play()
	area.sparkle(3)
	area.queue_free()

func make_coin_flip(side: String) -> void:
	var new_coin_flip = COIN_FLIP_ANIM.instantiate()
	new_coin_flip.mode = side
	add_child(new_coin_flip)

func take_damage() -> void:
	if !invulnerable:
		$Damage.play()
		Global.camera_shake += 4
		shake = 2
		invulnerable = true
		var popup := Global.instantiate_text("1", Color.RED)
		popup.position = Vector2(0, z)
		add_child(popup)
		Global.game_variables.hp -= 1
		await Global.make_timer(2).timeout
		invulnerable = false
