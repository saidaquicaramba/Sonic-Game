extends Area2D

@export var coin_value = 1

func _ready():
	set_collision_layer_value(6, true)
	set_collision_mask_value(1, true)
	
	area_entered.connect(_on_area_entered)

func _on_area_entered(area):
	if area.is_in_group("player"):
		GameManager.add_coins(coin_value)
		print("Moeda coletada! Total: %d" % GameManager.get_coins())
		queue_free()

func take_damage():
	queue_free()
