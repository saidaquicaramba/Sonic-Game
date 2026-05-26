extends CharacterBody2D

@export var speed = 0.0  # Sem movimento horizontal
@export var jump_force = -320.0
@export var jump_interval = 1.5
@export var spawn_y_bottom = 750.0  # Vem de baixo
@export var despawn_y = -100.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var jump_timer = 0.0
var start_x = 0.0
var is_moving_up = false

func _ready():
	set_collision_layer_value(4, true)  # Piranha layer
	set_collision_mask_value(2, true)   # Plataformas
	set_collision_mask_value(1, true)   # Player
	
	start_x = global_position.x
	jump_timer = randf_range(0.3, jump_interval)

func _physics_process(delta):
	# Verificar se está subindo (velocidade negativa = subindo)
	if velocity.y < 0:
		is_moving_up = true
	elif velocity.y > 0:
		is_moving_up = false
	
	# Aplicar gravidade normalmente
	if not is_on_floor():
		velocity.y += gravity * delta
	
	# SEM movimento horizontal
	velocity.x = 0
	
	# Sistema de pulo automático
	jump_timer -= delta
	if jump_timer <= 0 and is_on_floor():
		velocity.y = jump_force
		jump_timer = jump_interval + randf_range(-0.2, 0.2)
	
	move_and_slide()
	
	# Despawnar se subiu demais (saiu pela tela de cima)
	if global_position.y < despawn_y:
		queue_free()
	
	# Detectar colisão com player
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		
		if collider and collider.is_in_group("player"):
			var relative_y = collider.global_position.y - global_position.y
			var is_above = relative_y < -12
			var is_descending = collider.velocity.y > 0
			
			if is_above and is_descending:
				take_damage()
				collider.velocity.y = -350
			else:
				if not collider.is_invulnerable:
					collider.take_damage()

func take_damage():
	print("Piranha destruída!")
	queue_free()
