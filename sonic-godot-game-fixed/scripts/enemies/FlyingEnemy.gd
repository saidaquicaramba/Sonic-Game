extends CharacterBody2D

@export var speed = 140.0
@export var direction = 1
@export var patrol_distance = 300.0
@export var float_amplitude = 25.0
@export var float_speed = 3.0

var start_position = Vector2.ZERO
var float_timer = 0.0
var direction_locked = false

func _ready():
	set_collision_layer_value(5, true)
	set_collision_mask_value(2, true)
	set_collision_mask_value(1, true)
	start_position = global_position

func _physics_process(delta):
	velocity.y = 0
	
	velocity.x = speed * direction
	
	if not direction_locked:
		if abs(global_position.x - start_position.x) >= patrol_distance:
			direction *= -1
			direction_locked = true
	else:
		if abs(global_position.x - start_position.x) < patrol_distance - 20:
			direction_locked = false
	
	float_timer += delta * float_speed
	velocity.y = sin(float_timer) * float_amplitude
	
	move_and_slide()
	
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		
		if collider and collider.is_in_group("player"):
			if not collider.is_invulnerable:
				collider.take_damage()

func take_damage():
	print("Inimigo voador destruído!")
	queue_free()
