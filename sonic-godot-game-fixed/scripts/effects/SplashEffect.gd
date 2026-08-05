extends Node2D

@export var lifetime = 0.5
@export var particle_count = 8

func _ready():
	for i in range(particle_count):
		var angle = (TAU / particle_count) * i
		var particle = create_particle(angle)
		add_child(particle)
	
	await get_tree().create_timer(lifetime).timeout
	queue_free()

func create_particle(angle: float) -> Node2D:
	var particle = Node2D.new()
	var speed = randf_range(100, 200)
	var velocity = Vector2(cos(angle), sin(angle)) * speed
	
	var rect = ColorRect.new()
	rect.size = Vector2(4, 4)
	rect.color = Color(0.8, 0.2, 1, 1)
	
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(rect, "position", rect.position + velocity * lifetime, lifetime)
	tween.tween_property(rect, "modulate:a", 0, lifetime)
	
	particle.add_child(rect)
	return particle
