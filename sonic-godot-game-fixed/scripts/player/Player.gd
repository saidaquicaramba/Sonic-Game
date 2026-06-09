extends CharacterBody2D

@onready var ponto_attack: Area2D = $pontoAttack
@onready var ponto_attack_2: CollisionShape2D = $pontoAttack/pontoAttack2
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var player_hit_box: Area2D = $playerHitBox

# Variaveis de Movimento (Sonic-like)
@export var max_speed = 400.0
@export var jump_force = -800.0
@export var acceleration = 50.0
@export var friction = 30.0
@export var max_lives = 3
@export var gravity_value = 2000.0

# Variaveis de Ataque (do Ponto-Final)
@export var attack_duration = 3.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var current_lives = 3
var is_invulnerable = false
var invulnerability_time = 2.0
var invulnerability_timer = 0.0
var blink_speed = 0.1
var blink_timer = 0.0
var is_visible_state = true
var can_move = true
var dir = 0

func _ready():
	set_collision_layer_value(1, true)  # Player layer
	set_collision_mask_value(2, true)   # Plataformas
	set_collision_mask_value(3, true)   # Inimigos patrulhadores
	set_collision_mask_value(4, true)   # Piranhas
	set_collision_mask_value(5, true)   # Voadores
	
	current_lives = max_lives
	GameManager.set_player(self)
	ponto_attack_2.disabled = true

func _physics_process(delta):
	# Aplicar gravidade customizada
	if not is_on_floor():
		velocity.y += gravity_value * delta
	
	# Movimento horizontal com aceleração
	dir = Input.get_axis("move_left", "move_right")
	
	if dir != 0 and can_move:
		velocity.x = move_toward(velocity.x, dir * max_speed, acceleration * delta * 60)
	else:
		velocity.x = move_toward(velocity.x, 0, friction * delta * 60)
	
	# Pulo
	if Input.is_action_just_pressed("jump") and is_on_floor() and can_move:
		velocity.y = jump_force
	
	move_and_slide()
	
	# Verificar queda fora do mapa
	if global_position.y > 2800:  # 4x maior
		_respawn()
	
	# Gerenciar invulnerabilidade
	if is_invulnerable:
		invulnerability_timer -= delta
		blink_timer -= delta
		
		if blink_timer <= 0:
			is_visible_state = not is_visible_state
			blink_timer = blink_speed
			sprite_2d.visible = is_visible_state
		
		if invulnerability_timer <= 0:
			is_invulnerable = false
			sprite_2d.visible = true

func _process(delta: float) -> void:
	# Sistema de ataque (ui_down)
	if Input.is_action_just_pressed("ui_down") and can_move:
		can_move = false
		ponto_attack_2.disabled = false
		await (get_tree().create_timer(attack_duration).timeout)
		can_move = true
		ponto_attack_2.disabled = true

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
		velocity.y = jump_force * 0.5

func get_lives():
	return current_lives
