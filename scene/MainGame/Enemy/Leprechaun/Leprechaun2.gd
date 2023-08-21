extends Enemy
class_name Leprechaun2

enum States {
	IDLE,
	WALKING,
	ATTACK,
	DIE
}

const PROJECTILE = preload("res://scene/MainGame/Enemy/Projectile/EnemyBasicProjectile.tscn")

var state := States.IDLE
var angle: float = 0
var state_timer: float = 0
var dead: bool = false
var value: int = 6
var shake: float = 0
var velocity := Vector2.ZERO
var z: float = 0
var zsp: float = 0
var g: float = 300
@export var is_attacking: bool = false

func _ready():
	hp = 2
	change_state(States.WALKING)

func _process(delta):
	if velocity.x != 0:
		$Draw.scale.x = sign(velocity.x)
	if state == States.WALKING:
		state_timer += delta
		if state_timer >= 2:
			change_state(States.ATTACK)
		angle = position.angle_to_point(Global.game_variables.player_position)
	elif state == States.DIE:
		shake = 2
	if z < 0:
		zsp += g * delta
		z += zsp * delta
	else:
		z = 0
	position += velocity * delta
	if position.y != clamp(position.y, 0, 200):
		queue_free()

func _physics_process(delta):
	$Draw.position.y = z
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
	if state == States.IDLE:
		%Body.play("default")
	elif state == States.ATTACK:
		if position.x < Global.game_variables.player_position.x:
			$Draw.scale.x = 1
		else:
			$Draw.scale.x = -1
		z = -1
		zsp = -50
		velocity = Vector2.ZERO
		%Body.play("walk")
		$AnimationPlayer.play("AttackMell")
	elif state == States.WALKING:
		velocity = 50 * Vector2.from_angle(randf_range(0, 2*PI))
		%Body.play("walk")
	elif state == States.DIE:
		%Body.play("die")
		$AnimationPlayer.play("Die")

func attack() -> void:
	velocity = 150 * Vector2.from_angle(position.angle_to_point(Global.game_variables.player_position))

func take_damage(amount: int) -> void:
	hp -= amount
	shake += amount * 2
	if dead:
		for i in amount:
			var coin := Global.instantiate_coin()
			coin.position = position
			call_deferred("add_sibling", coin)
	else:
		$Hurt.play()
	z = -1
	zsp = -100
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
			tween.tween_property(self, "velocity", Vector2.ZERO, 1.5).set_ease(Tween.EASE_IN)
		change_state(States.DIE)

func _on_activate_body_entered(body):
	if body is Player:
		if state == States.IDLE:
			state = States.WALKING


func _on_activate_body_exited(body):
	if body is Player:
		if state == States.WALKING or state == States.ATTACK:
			state = States.IDLE

func _on_body_entered(body):
	if body is Player and !dead:
		body.take_damage()
	else:
		z = -1
		zsp = -50
		velocity = -velocity * 0.75
