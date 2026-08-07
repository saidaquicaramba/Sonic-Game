extends CharacterBody2D
## Plataforma que se move em padrões definidos
## Pode ser configurada para se mover horizontalmente, verticalmente ou em ambas

class_name MovingPlatform

@export var move_direction: Vector2 = Vector2(1, 0)  # Direção de movimento
@export var move_distance: float = 200.0  # Distância total de movimento
@export var move_speed: float = 100.0  # Velocidade de movimento
@export var move_type: String = "linear"  # "linear", "sine_wave", "pulse"

var start_position: Vector2
var current_target: Vector2
var time_elapsed: float = 0.0
var direction_toggle: int = 1

func _ready():
	set_collision_layer_value(2, true)  # Platform layer
	set_collision_mask_value(1, true)   # Detectar player
	start_position = global_position
	current_target = start_position + (move_direction.normalized() * move_distance)

func _physics_process(delta):
	match move_type:
		"linear":
			_linear_movement(delta)
		"sine_wave":
			_sine_wave_movement(delta)
		"pulse":
			_pulse_movement(delta)
	
	move_and_slide()

func _linear_movement(delta):
	# Movimento linear ida e volta
	var distance_to_target = global_position.distance_to(current_target)
	
	if distance_to_target < 5:
		# Inverte direção
		direction_toggle *= -1
		current_target = start_position + (move_direction.normalized() * move_distance * direction_toggle)
	
	var direction = (current_target - global_position).normalized()
	velocity = direction * move_speed

func _sine_wave_movement(delta):
	# Movimento suave em onda senoidal
	time_elapsed += delta
	var offset = sin(time_elapsed * move_speed / 50.0) * move_distance
	global_position = start_position + (move_direction.normalized() * offset)
	velocity = Vector2.ZERO

func _pulse_movement(delta):
	# Movimento com pausa entre ciclos
	time_elapsed += delta
	var cycle_duration = (move_distance * 2) / move_speed
	var current_cycle = fmod(time_elapsed, cycle_duration)
	var half_cycle = cycle_duration / 2
	
	if current_cycle < half_cycle:
		var progress = current_cycle / half_cycle
		global_position = start_position.lerp(
			start_position + (move_direction.normalized() * move_distance),
			progress
		)
	else:
		var progress = (current_cycle - half_cycle) / half_cycle
		global_position = (start_position + (move_direction.normalized() * move_distance)).lerp(
			start_position,
			progress
		)
	
	velocity = Vector2.ZERO
