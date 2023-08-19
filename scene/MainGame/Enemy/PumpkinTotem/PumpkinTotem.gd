extends Enemy
class_name PumpkinTotem

enum States {
	IDLE,
	TRACKING,
	ATTACK,
	DIE
}

const PROJECTILE = preload("res://scene/MainGame/Enemy/Projectile/EnemyBasicProjectile.tscn")

var state := States.ATTACK
var angle: float = 0
var rotations: Array[Vector2] = [
	Vector2(17, 12), Vector2(33, 12), Vector2(33, 1), Vector2(17, 1)
]
var state_timer: float = 0
@export var is_attacking: bool = false

func _ready():
	hp = 3
	change_state(States.TRACKING)

func _process(delta):
	if state == States.TRACKING:
		state_timer += delta
		if state_timer >= 2:
			change_state(States.ATTACK)
		angle = position.angle_to_point(Global.game_variables.player_position)
	elif state == States.DIE:
		$Draw.position.x = randf_range(-2, 2)
	%Head.region_rect.position = rotations[int(wrapf(angle, 0, 2*PI)/(0.5*PI))] + Vector2(32, 0) * int(is_attacking)

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
	if hp <= 0:
		change_state(States.DIE)
