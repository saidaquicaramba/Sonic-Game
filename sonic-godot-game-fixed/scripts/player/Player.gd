extends CharacterBody2D

@onready var ponto_attack: Area2D = $pontoAttack
@onready var ponto_attack_2: CollisionShape2D = $pontoAttack/pontoAttack2
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var player_hit_box_2: CollisionShape2D = $playerHitBox/playerHitBox2
@onready var player_hit_box: Area2D = $playerHitBox

# Variaveis PONTO-FINAL (PRIORIDADE)
var maxSpeed = 700
var maxSpeedFloat = 1.5
var accel = 1000
var accelFloat = 1
var decel = 500
var decelFloat = 1

var jumpForce = -1200
var jumpPhysics = true
var movePhysics = true
var dir = 0
var gravity = 2000

var canMove = true
var is_invulnerable = false

func _physics_process(delta):
	# Gravidade
	if not is_on_floor():
		velocity.y += gravity * delta
	
	dir = Input.get_axis("ui_left", "ui_right")
	
	# Movimentação (PONTO-FINAL)
	if dir != 0 and movePhysics and canMove == true:
		velocity.x = move_toward(velocity.x, maxSpeed * maxSpeedFloat * dir, accel * accelFloat * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, decel * decelFloat * delta)
	
	if is_on_floor() and jumpPhysics and Input.is_action_just_pressed("ui_accept") and canMove == true:
		velocity.y = jumpForce
	
	move_and_slide()
	
	# Verificar queda fora do mapa
	if global_position.y > 2800:
		_respawn()

func _ready() -> void:
	set_collision_layer_value(1, true)
	set_collision_mask_value(2, true)
	set_collision_mask_value(3, true)
	
	ponto_attack_2.disabled = true
	GameManager.set_player(self)

func _process(delta: float) -> void:
	# Sistema de ataque (ui_down) - PONTO-FINAL
	if Input.is_action_just_pressed("ui_down"):
		canMove = false
		ponto_attack_2.disabled = false
		await (get_tree().create_timer(3).timeout)
		canMove = true
		ponto_attack_2.disabled = true
	
	# Invulnerabilidade - PONTO-FINAL
	if is_invulnerable == true:
		set_collision_mask_value(2, false)
		await (get_tree().create_timer(2).timeout)
		set_collision_mask_value(2, true)
		is_invulnerable = false

func _respawn():
	global_position = Vector2(100, 300)
	velocity = Vector2.ZERO

func take_damage():
	print("Player tomou dano!")
	if not is_invulnerable:
		is_invulnerable = true
