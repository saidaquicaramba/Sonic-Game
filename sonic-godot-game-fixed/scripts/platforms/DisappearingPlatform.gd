extends CharacterBody2D
## Plataforma que desaparece e reaparece em ciclos
## Desafia o jogador a passar antes de desaparecer

class_name DisappearingPlatform

@export var visible_time: float = 3.0  # Quanto tempo fica visível
@export var invisible_time: float = 2.0  # Quanto tempo fica invisível
@export var use_alpha_fade: bool = true  # Se usa fade de alpha

var time_elapsed: float = 0.0
var is_visible: bool = true
var cycle_time: float = 0.0

@onready var collision_shape = $CollisionShape2D
@onready var color_rect = $ColorRect

func _ready():
	set_collision_layer_value(2, true)  # Platform layer
	set_collision_mask_value(1, true)   # Detectar player
	cycle_time = visible_time + invisible_time

func _physics_process(delta):
	time_elapsed += delta
	var progress_in_cycle = fmod(time_elapsed, cycle_time)
	
	if progress_in_cycle < visible_time:
		# Período visível
		if not is_visible:
			is_visible = true
			_set_visible(true)
	else:
		# Período invisível
		if is_visible:
			is_visible = false
			_set_visible(false)
	
	# Efeito visual de fade
	if use_alpha_fade:
		var fade_time = 0.3  # Tempo de transição
		var progress_in_period = fmod(progress_in_cycle, visible_time if is_visible else invisible_time)
		var alpha = 1.0
		
		if progress_in_period > (visible_time - fade_time) and is_visible:
			# Fadeout no final do período visível
			alpha = 1.0 - (progress_in_period - (visible_time - fade_time)) / fade_time
		elif progress_in_period < fade_time and not is_visible:
			# Não mostrar durante invisível
			alpha = 0.0
		
		modulate.a = alpha

func _set_visible(visible: bool):
	collision_shape.set_deferred("disabled", not visible)
	if visible:
		modulate.a = 1.0
	else:
		modulate.a = 0.0

func _on_body_entered(body):
	# Se o jogador está em cima quando desaparece, causa dano
	if body.is_in_group("player") and not is_visible:
		body.take_damage()
