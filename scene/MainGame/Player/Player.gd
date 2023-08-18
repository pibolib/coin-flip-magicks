extends CharacterBody2D

var z: float = -8
var flip_sprite := false
var movement_speed: float = 75
var movement_vector := Vector2.ZERO
var aim_angle: float = 0

func _ready():
	$Sprite.play("default")

func _process(delta):
	#block dedicated to updating visuals
	$Sprite.position.y = z
	$Sprite.flip_h = flip_sprite
	aim_angle = position.angle_to_point(get_global_mouse_position())
	
	movement_vector = Vector2.ZERO
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
	if movement_vector != Vector2.ZERO:
		velocity = movement_speed * movement_vector.normalized()
	else:
		velocity = Vector2.ZERO
	move_and_slide()

func _physics_process(delta):
	z = lerp(z, -8 + 2*sin(Global.time*8), 0.1)
	$Target.rotation = lerp_angle($Target.rotation, aim_angle, 0.5)
