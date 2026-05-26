extends CharacterBody2D

@export var speed = 200.0
@export var jump_force = -400.0
@export var acceleration = 25.0
@export var friction = 20.0
@export var max_lives = 3

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var current_lives = 3
var is_invulnerable = false
var invulnerability_time = 2.0
var invulnerability_timer = 0.0
var blink_speed = 0.1
var blink_timer = 0.0
var is_visible_state = true

func _ready():
	set_collision_layer_value(1, true)  # Player layer
	set_collision_mask_value(2, true)   # Plataformas
	set_collision_mask_value(3, true)   # Inimigos patrulhadores
	set_collision_mask_value(4, true)   # Piranhas
	set_collision_mask_value(5, true)   # Voadores
	
	current_lives = max_lives
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
	
	# Pulo
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_force
	
	move_and_slide()
	
	# Verificar queda fora do mapa
	if global_position.y > 700:
		_respawn()
	
	# Gerenciar invulnerabilidade
	if is_invulnerable:
		invulnerability_timer -= delta
		blink_timer -= delta
		
		if blink_timer <= 0:
			is_visible_state = not is_visible_state
			blink_timer = blink_speed
			$ColorRect.visible = is_visible_state
		
		if invulnerability_timer <= 0:
			is_invulnerable = false
			$ColorRect.visible = true

func _respawn():
	global_position = Vector2(100, 300)
	velocity = Vector2.ZERO
	take_damage()

func take_damage():
	if is_invulnerable:
		return
	
	current_lives -= 1
	print("Player tomou dano! Vidas restantes: ", current_lives)
	
	if current_lives <= 0:
		print("GAME OVER!")
		global_position = Vector2(100, 300)
		current_lives = max_lives
		velocity = Vector2.ZERO
	else:
		# Ativar invulnerabilidade
		is_invulnerable = true
		invulnerability_timer = invulnerability_time
		blink_timer = blink_speed
		velocity.y = jump_force * 0.75  # Pequeno pulo ao tomar dano

func get_lives():
	return current_lives
