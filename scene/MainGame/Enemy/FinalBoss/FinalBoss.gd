extends Enemy
class_name FinalBoss

enum States {
	IDLE,
	WAIT,
	ATTACK_CHOOSE,
	ATTACK1,
	ATTACK2,
	SUMMON,
	DIE
}

const PROJECTILE = preload("res://scene/MainGame/Enemy/Projectile/EnemyBasicProjectile.tscn")
const PROJECTILE_2 = preload("res://scene/MainGame/Enemy/Projectile/EnemyBasicProjectile2.tscn")
const COIN_FLIP = preload("res://scene/MainGame/Player/CoinFlipAnim.tscn")
const LASER = preload("res://scene/MainGame/Enemy/Projectile/EnemyBeam.tscn")
const SUMMON = preload("res://scene/MainGame/Enemy/Leprechaun/Leprechaun2.tscn")

var state := States.IDLE
var angle: float = 0
var rotations: Array[Vector2] = [
	Vector2(17, 12), Vector2(33, 12), Vector2(33, 1), Vector2(17, 1)
]
var state_timer: float = 0
var dead: bool = false
var value: int = 19
var shake: float = 0
var count: int = 0
@export var is_attacking: bool = false
var hp_threshold = 37

func _ready():
	hp = 50
	change_state(States.IDLE)
	$Draw/Main.play("Idle")

func _process(delta):
	if state == States.WAIT:
		state_timer += delta
		if hp < hp_threshold:
			hp_threshold -= 12
			change_state(States.SUMMON)
		if state_timer >= 2:
			change_state(States.ATTACK_CHOOSE)
		angle = position.angle_to_point(Global.game_variables.player_position)
	elif state == States.DIE:
		shake = 2

func _physics_process(delta):
	if shake >= 0.5:
		$Draw.position.x = randf_range(-shake, shake)
		shake -= delta * 8

func fire_projectile(angle_mod: float) -> void:
	var projectile = PROJECTILE.instantiate()
	projectile.position = position
	projectile.angle = angle + angle_mod
	projectile.speed = 300
	add_sibling(projectile)

func fire_laser(angle_mod: float) -> void:
	var projectile = LASER.instantiate()
	projectile.position = position
	projectile.angle = angle + angle_mod
	add_sibling(projectile)

func fire_projectiles_noaim() -> void:
	for i in 20:
		var projectile = PROJECTILE_2.instantiate()
		projectile.position = position
		projectile.angle = deg_to_rad(18*i)
		add_sibling(projectile)

func summon_enemies() -> void:
	for i in 2:
		var new_enemy = SUMMON.instantiate()
		new_enemy.position = position + Vector2.from_angle(randf_range(0, 2*PI))*16
		add_sibling(new_enemy)

func change_state(new_state: States) -> void:
	state_timer = 0
	state = new_state
	if state == States.IDLE or state == States.WAIT or state == States.ATTACK_CHOOSE:
		$AnimationPlayer.play("Idle")
	if state == States.SUMMON:
		$AnimationPlayer.play("Summon")
	if state == States.ATTACK_CHOOSE:
		var choice: int = randi() % 2
		var new_coin = COIN_FLIP.instantiate()
		if choice == 0:
			new_coin.mode = "Heads"
		else:
			new_coin.mode = "Tails"
		add_child(new_coin)
		await Global.make_timer(0.5).timeout
		if choice == 0:
			change_state(States.ATTACK1)
		else:
			change_state(States.ATTACK2)
	elif state == States.ATTACK1:
		count += 1
		if count % 2 == 1:
			$AnimationPlayer.play("Attack1")
		else:
			$AnimationPlayer.play("Attack1_mod")
	elif state == States.ATTACK2:
		$AnimationPlayer.play("Attack2")
	elif state == States.DIE:
		$AnimationPlayer.play("Die")

func take_damage(amount: int) -> void:
	if state != States.IDLE and state != States.SUMMON:
		hp -= amount
		shake += amount * 4
		if dead:
			for i in amount:
				var coin := Global.instantiate_coin()
				coin.position = position
				call_deferred("add_sibling", coin)
		else:
			$Hurt.play()
		var popup := Global.instantiate_text("%d" % amount)
		add_child(popup)
		modulate = Color.RED
		var tween := get_tree().create_tween()
		tween.tween_property(self, "modulate", Color.WHITE, 0.25)
		if hp <= 0:
			if !dead:
				dead = true
				Global.play_bgm(Global.bgm1)
				Global.game_variables.in_boss = false
				Global.game_variables.win = true
				for i in value:
					var coin := Global.instantiate_coin()
					coin.position = position
					call_deferred("add_sibling", coin)
				change_state(States.DIE)
