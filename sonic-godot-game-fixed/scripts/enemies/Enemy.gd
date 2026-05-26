extends CharacterBody2D

@export var speed = 100.0
@export var direction = 1
@export var patrol_distance = 200.0

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
	
	velocity.x = speed * direction
	
	# Verificar limites de patrulha
	if abs(global_position.x - start_position.x) > patrol_distance:
		direction *= -1
	
	move_and_slide()
	
	# Detectar colisão com player com hitbox precisa
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		
		if collider and collider.is_in_group("player"):
			# Verificar se player está acima (15px de margem)
			var player_top = collider.global_position.y - 24  # Metade da altura do player
			var enemy_top = global_position.y - 16  # Metade da altura do inimigo
			var contact_margin = 15
			
			# Se player pulou em cima do inimigo
			if collider.velocity.y > 0 and player_top < enemy_top - contact_margin:
				take_damage()
				collider.velocity.y = -300  # Quique ao matar inimigo
			else:
				# Colisão lateral = dano no player
				collider.take_damage()

func take_damage():
	print("Inimigo destruído!")
	queue_free()
