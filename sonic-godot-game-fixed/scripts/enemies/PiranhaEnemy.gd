extends CharacterBody2D

@export var speed = 150.0
@export var jump_force = -350.0
@export var jump_interval = 2.0
@export var spawn_position_x = 1400.0
@export var despawn_distance = -100.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var jump_timer = 0.0
var player_ref = null
var is_jumping = false

func _ready():
	set_collision_layer_value(4, true)  # Piranha layer
	set_collision_mask_value(2, true)   # Plataformas
	set_collision_mask_value(1, true)   # Player
	
	jump_timer = randf_range(0.5, jump_interval)
	global_position.x = spawn_position_x

func _physics_process(delta):
	# Aplicar gravidade
	if not is_on_floor():
		velocity.y += gravity * delta
	
	# Movimento horizontal (sempre para esquerda em direção ao player)
	velocity.x = -speed
	
	# Sistema de pulo automático
	jump_timer -= delta
	if jump_timer <= 0 and is_on_floor():
		velocity.y = jump_force
		jump_timer = jump_interval + randf_range(-0.3, 0.3)  # Variação para parecer mais natural
	
	move_and_slide()
	
	# Despawnar se saiu da tela
	if global_position.x < despawn_distance:
		queue_free()
	
	# Detectar colisão com player
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		
		if collider and collider.is_in_group("player"):
			# Verificar se player está acima (para não criar exploit)
			var player_top = collider.global_position.y - 24
			var enemy_top = global_position.y - 16
			var contact_margin = 15
			
			# Se player pulou em cima
			if collider.velocity.y > 0 and player_top < enemy_top - contact_margin:
				take_damage()
				collider.velocity.y = -300
			else:
				# Dano no player
				collider.take_damage()

func take_damage():
	print("Piranha destruída!")
	queue_free()
