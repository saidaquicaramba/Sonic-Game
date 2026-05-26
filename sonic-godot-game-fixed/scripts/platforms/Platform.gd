extends StaticBody2D

func _ready():
	set_collision_layer_value(2, true)  # Platform layer
	set_collision_mask_value(1, true)   # Player
