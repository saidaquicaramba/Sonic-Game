extends CharacterBody2D

@export var speed = 120.0
@export var direction = 1
@export var patrol_distance = 250.0

var start_position = Vector2.ZERO
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction_locked = false

func _ready():
	set_collision_layer_value(3, true)
	set_collision_mask_value(2, true)
	set_collision_mask_value(1, true)
	start_position = global_position

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	
	velocity.x = speed * direction
	
	if not direction_locked:
		if abs(global_position.x - start_position.x) >= patrol_distance:
			direction *= -1
			direction_locked = true
	else:
		if abs(global_position.x - start_position.x) < patrol_distance - 20:
			direction_locked = false
	
	move_and_slide()
	
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
	print("Inimigo patrulhador destruído!")
	queue_free()
