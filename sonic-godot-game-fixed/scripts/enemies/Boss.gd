extends CharacterBody2D

@export var speed = 150.0
@export var jump_force = -600.0
@export var patrol_distance = 400.0
@export var health = 5
@export var attack_cooldown = 2.0

var start_position = Vector2.ZERO
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction = 1
var direction_locked = false
var attack_timer = 0.0
var current_health = 0

func _ready():
	set_collision_layer_value(3, true)
	set_collision_mask_value(2, true)
	set_collision_mask_value(1, true)
	
	start_position = global_position
	current_health = health
	attack_timer = attack_cooldown

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
	
	attack_timer -= delta
	if attack_timer <= 0:
		jump_attack()
		attack_timer = attack_cooldown
	
	move_and_slide()
	
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		
		if collider and collider.is_in_group("player"):
			var relative_y = collider.global_position.y - global_position.y
			var is_above = relative_y < -25
			var is_descending = collider.velocity.y > 0
			
			if is_above and is_descending:
				take_damage()
				collider.velocity.y = -400
			else:
				if not collider.is_invulnerable:
					collider.take_damage()

func jump_attack():
	if is_on_floor():
		velocity.y = jump_force
		print("Boss ataca!")

func take_damage():
	current_health -= 1
	print("Boss levou dano! HP: %d/%d" % [current_health, health])
	
	if current_health <= 0:
		die()

func die():
	print("Boss derrotado!")
	queue_free()
