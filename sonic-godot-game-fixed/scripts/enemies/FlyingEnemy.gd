extends CharacterBody2D

@export var speed = 140.0
@export var direction = 1
@export var patrol_distance = 300.0
@export var float_amplitude = 20.0
@export var float_speed = 2.0

var start_position = Vector2.ZERO
var float_timer = 0.0

func _ready():
	set_collision_layer_value(5, true)  # Flying Enemy layer
	set_collision_mask_value(2, true)   # Plataformas
	set_collision_mask_value(1, true)   # Player
	start_position = global_position

func _physics_process(delta):
	# SEM gravidade - voa!
	# Reseta velocity.y para calcular novo
	velocity.y = 0
	
	# Movimento horizontal
	velocity.x = speed * direction
	
	# Movimento vertical flutuante (onda suave)
	float_timer += delta * float_speed
	velocity.y = sin(float_timer) * float_amplitude
	
	# Aplicar movimento
	move_and_slide()
	
	# Verificar limites de patrulha
	if abs(global_position.x - start_position.x) > patrol_distance:
		direction *= -1
	
	# Detectar colisão com player
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		
		if collider and collider.is_in_group("player"):
			if not collider.is_invulnerable:
				collider.take_damage()

func take_damage():
	print("Inimigo voador destruído!")
	queue_free()
