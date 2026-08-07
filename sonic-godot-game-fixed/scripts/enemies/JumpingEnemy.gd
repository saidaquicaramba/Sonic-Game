extends CharacterBody2D
## Inimigo que pula periodicamente
## Cria desafios verticais adicionais

class_name JumpingEnemy

@export var speed = 100.0
@export var direction = 1
@export var patrol_distance = 250.0
@export var jump_force = -800.0
@export var jump_interval = 3.0  # Tempo entre pulos

var start_position = Vector2.ZERO
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction_locked = false
var time_since_jump = 0.0

func _ready():
	set_collision_layer_value(3, true)  # Enemy layer
	set_collision_mask_value(2, true)   # Platform
	set_collision_mask_value(1, true)   # Player
	start_position = global_position
	add_to_group("enemy")

func _physics_process(delta):
	# Gravidade
	if not is_on_floor():
		velocity.y += gravity * delta
	
	# Movimento horizontal
	velocity.x = speed * direction
	
	# Patrulha
	if not direction_locked:
		if abs(global_position.x - start_position.x) >= patrol_distance:
			direction *= -1
			direction_locked = true
	else:
		if abs(global_position.x - start_position.x) < patrol_distance - 20:
			direction_locked = false
	
	# Pulo periódico
	time_since_jump += delta
	if is_on_floor() and time_since_jump >= jump_interval:
		velocity.y = jump_force
		time_since_jump = 0.0
	
	move_and_slide()
	
	# Detecção de colisão com o jogador
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		
		if collider and collider.is_in_group("player"):
			var relative_y = collider.global_position.y - global_position.y
			var is_above = relative_y < -12
			var is_descending = collider.velocity.y > 0
			
			if is_above and is_descending:
				# Pula ao ser pisado
				take_damage()
				collider.velocity.y = -350
			else:
				# Causa dano no jogador
				if not collider.is_invulnerable:
					collider.take_damage()

func take_damage():
	print("Inimigo saltador destruído!")
	queue_free()
