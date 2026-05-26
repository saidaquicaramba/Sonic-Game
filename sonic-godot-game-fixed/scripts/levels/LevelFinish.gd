extends Area2D

func _ready():
	set_collision_layer_value(4, true)   # Hitbox layer
	set_collision_mask_value(1, true)    # Detectar Player
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.is_in_group("player"):
		print("Fase concluída! Próxima fase...")
		GameManager.next_level()
