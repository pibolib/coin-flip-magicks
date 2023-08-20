extends Enemy
class_name PumpkinTotem2

enum States {
	IDLE,
	TRACKING,
	ATTACK,
	DIE
}

const PROJECTILE = preload("res://scene/MainGame/Enemy/Projectile/EnemyBasicProjectile2.tscn")

var state := States.IDLE
var angle: float = 0
var rotations: Array[Vector2] = [
	Vector2(17, 52), Vector2(33, 52), Vector2(33, 41), Vector2(17, 41)
]
var state_timer: float = 0
var dead: bool = false
var value: int = 8
var shake: float = 0
@export var is_attacking: bool = false

func _ready():
	hp = 5
	change_state(States.IDLE)

func _process(delta):
	if state == States.TRACKING:
		state_timer += delta
		if state_timer >= 2:
			change_state(States.ATTACK)
		angle = position.angle_to_point(Global.game_variables.player_position)
	elif state == States.DIE:
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
	projectile.source = self
	add_sibling(projectile)

func change_state(new_state: States) -> void:
	state_timer = 0
	state = new_state
	if state == States.ATTACK:
		$AnimationPlayer.play("Attack2")
	elif state == States.DIE:
		$AnimationPlayer.play("Die")

func take_damage(amount: int) -> void:
	hp -= amount
	shake += amount * 4
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
		change_state(States.DIE)



func _on_activate_body_entered(body):
	if body is Player:
		if state == States.IDLE:
			state = States.TRACKING


func _on_activate_body_exited(body):
	if body is Player:
		if state == States.TRACKING or state == States.ATTACK:
			state = States.IDLE
