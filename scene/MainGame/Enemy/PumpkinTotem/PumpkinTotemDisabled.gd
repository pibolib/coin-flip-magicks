extends Enemy
class_name PumpkinTotemDisabled

enum States {
	IDLE,
	TRACKING,
	ATTACK,
	DIE
}

const PROJECTILE = preload("res://scene/MainGame/Enemy/Projectile/EnemyBasicProjectile.tscn")

var state := States.ATTACK
var angle: float = PI/2
var rotations: Array[Vector2] = [
	Vector2(17, 76), Vector2(33, 76), Vector2(33, 65), Vector2(17, 65)
]
var state_timer: float = 0
var dead: bool = false
var value: int = 7
var shake: float = 0
@export var is_attacking: bool = false

func _ready():
	hp = 3

func _process(_delta):
	if state == States.DIE:
		shake = 2
	%Head.region_rect.position = rotations[int(wrapf(angle, 0, 2*PI)/(0.5*PI))] + Vector2(32, 0) * int(is_attacking)

func _physics_process(delta):
	if shake >= 0.5:
		$Draw.position.x = randf_range(-shake, shake)
		shake -= delta * 8

func fire_projectile(angle_mod: float) -> void:
	var projectile = PROJECTILE.instantiate()
	projectile.position = position
	projectile.angle = angle + angle_mod
	add_sibling(projectile)

func change_state(new_state: States) -> void:
	state_timer = 0
	state = new_state
	if state == States.ATTACK:
		$AnimationPlayer.play("Attack")
	elif state == States.DIE:
		$AnimationPlayer.play("Die")

func take_damage(amount: int) -> void:
	hp -= amount
	shake += amount * 3
	if dead:
		for i in amount:
			var coin := Global.instantiate_coin()
			coin.position = position
			call_deferred("add_sibling", coin)
	var popup := Global.instantiate_text("%d" % amount)
	add_child(popup)
	modulate = Color.RED
	var tween := get_tree().create_tween()
	tween.tween_property(self, "modulate", Color.WHITE, 0.25)
	if hp <= 0:
		if !dead:
			dead = true
			for i in value:
				var coin := Global.instantiate_coin()
				coin.position = position
				call_deferred("add_sibling", coin)
			Global.game_variables.tutorial_enemies_killed += 1
		change_state(States.DIE)
