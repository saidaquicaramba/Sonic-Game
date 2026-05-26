extends CharacterBody2D

@export var speed = 120.0
@export var direction = 1
@export var patrol_distance = 250.0

var start_position = Vector2.ZERO
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	set_collision_layer_value(3, true)  # Enemy layer
	set_collision_mask_value(2, true)   # Plataformas
	set_collision_mask_value(1, true)   # Player
	start_position = global_position

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	
	# Movimento contínuo
	velocity.x = speed * direction
	
	# Verificar limites de patrulha - inverte suavemente
	if abs(global_position.x - start_position.x) > patrol_distance:
		direction *= -1
		# Corrigir para não ultrapassar limite
		global_position.x = start_position.x + (patrol_distance * direction)
	
	move_and_slide()
	
	# Detectar colisão com player
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		
		if collider and collider.is_in_group("player"):
			# Se player está acima do inimigo E descendo
			var relative_y = collider.global_position.y - global_position.y
			var is_above = relative_y < -12  # 12px de margem
			var is_descending = collider.velocity.y > 0
			
			if is_above and is_descending:
				# Player pisou no inimigo
				take_damage()
				collider.velocity.y = -350  # Quique
			else:
				# Colisão lateral
				if not collider.is_invulnerable:
					collider.take_damage()

func take_damage():
	print("Inimigo patrulhador destruído!")
	queue_free()
