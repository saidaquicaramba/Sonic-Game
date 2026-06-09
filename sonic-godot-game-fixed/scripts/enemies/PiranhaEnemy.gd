extends CharacterBody2D

@export var jump_force = -500.0  # Pulo bem alto
@export var jump_interval = 3.0  # Intervalo entre pulos
@export var screen_bottom = 720.0  # Posição Y máxima (fora da tela de baixo)
@export var despawn_y = -100.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var jump_timer = 0.0
var start_x = 0.0
var can_jump = true

func _ready():
	set_collision_layer_value(4, true)  # Piranha layer
	set_collision_mask_value(2, true)   # Plataformas
	set_collision_mask_value(1, true)   # Player
	
	start_x = global_position.x
	# Posiciona abaixo da tela no início
	global_position.y = screen_bottom
	jump_timer = randf_range(0.5, jump_interval)

func _physics_process(delta):
	# Aplicar gravidade normalmente
	if not is_on_floor():
		velocity.y += gravity * delta
	
	# SEM movimento horizontal - fica no mesmo X
	velocity.x = 0
	
	# Sistema de pulo automático - NÃO depende de is_on_floor()
	jump_timer -= delta
	if jump_timer <= 0:
		velocity.y = jump_force  # Pulo alto
		jump_timer = jump_interval + randf_range(-0.2, 0.3)
		print("Piranha pula!")
	
	move_and_slide()
	
	# Despawnar se subiu demais (saiu pela tela de cima)
	if global_position.y < despawn_y:
		queue_free()
	
	# Reposicionar abaixo da tela se caiu muito
	if global_position.y > screen_bottom:
		global_position.y = screen_bottom
		velocity.y = 0  # Reset velocity ao tocar o fundo
	
	# Detectar colisão com player
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		
		if collider and collider.is_in_group("player"):
			var relative_y = collider.global_position.y - global_position.y
			var is_above = relative_y < -15
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
