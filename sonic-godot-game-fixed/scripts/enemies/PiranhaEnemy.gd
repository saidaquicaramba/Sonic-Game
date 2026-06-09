extends CharacterBody2D

@export var jump_force = -500.0
@export var jump_interval = 3.0
@export var screen_bottom = 720.0
@export var despawn_y = -100.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var jump_timer = 0.0
var start_x = 0.0

func _ready():
	set_collision_layer_value(4, true)
	set_collision_mask_value(2, true)
	set_collision_mask_value(1, true)
	
	start_x = global_position.x
	global_position.y = screen_bottom
	jump_timer = randf_range(0.5, jump_interval)

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	
	velocity.x = 0
	
	jump_timer -= delta
	if jump_timer <= 0:
		velocity.y = jump_force
		jump_timer = jump_interval + randf_range(-0.2, 0.3)
		print("Piranha pula!")
	
	move_and_slide()
	
	if global_position.y < despawn_y:
		queue_free()
	
	if global_position.y > screen_bottom:
		global_position.y = screen_bottom
		velocity.y = 0
	
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
