extends Area2D
## Obstáculo de espinhos que causa dano ao jogador
## Deve ser evitado, não pode ser destruído

class_name Spike

@export var damage_cooldown: float = 0.5  # Cooldown entre danos

var last_damage_time: float = 0.0
var player_in_area: bool = false

func _ready():
	set_collision_layer_value(5, true)  # Hurtbox layer
	set_collision_mask_value(1, true)   # Detectar player
	area_entered.connect(_on_area_entered)

func _physics_process(delta):
	# Verifica se o jogador está em contato com os espinhos
	var overlapping_areas = get_overlapping_areas()
	for area in overlapping_areas:
		if area.name == "playerHitBox" and area.get_parent().is_in_group("player"):
			var player = area.get_parent()
			var current_time = Time.get_ticks_msec() / 1000.0
			
			if current_time - last_damage_time >= damage_cooldown:
				if not player.is_invulnerable:
					player.take_damage()
					last_damage_time = current_time
					print("Jogador atingido pelos espinhos!")

func _on_area_entered(area):
	# Detecção alternativa de colisão
	if area.get_parent() and area.get_parent().is_in_group("player"):
		var player = area.get_parent()
		var current_time = Time.get_ticks_msec() / 1000.0
		
		if current_time - last_damage_time >= damage_cooldown:
			if not player.is_invulnerable:
				player.take_damage()
				last_damage_time = current_time
				print("Jogador tocou os espinhos!")
