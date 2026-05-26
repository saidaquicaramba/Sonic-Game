extends CharacterBody2D

@export var speed = 200.0
@export var jump_force = -400.0
@export var acceleration = 25.0
@export var friction = 20.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	set_collision_layer_value(1, true)  # Player layer
	set_collision_mask_value(2, true)   # Plataformas
	set_collision_mask_value(3, true)   # Inimigos

	GameManager.set_player(self)

func _physics_process(delta):
	# Aplicar gravidade
	if not is_on_floor():
		velocity.y += gravity * delta

	# Movimento horizontal
	var input_x = Input.get_axis("move_left", "move_right")

	if input_x != 0:
		velocity.x = move_toward(velocity.x, input_x * speed, acceleration)
	else:
		velocity.x = move_toward(velocity.x, 0, friction)

	# Pulo — usa is_on_floor() nativo do CharacterBody2D
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_force

	move_and_slide()

	# Verificar queda fora do mapa
	if global_position.y > 700:
		_respawn()

func _respawn():
	global_position = Vector2(100, 300)
	velocity = Vector2.ZERO

func take_damage():
	print("Player tomou dano!")
	# Implementar sistema de vidas aqui
