extends Node

var current_level = 1
var player_instance = null

func get_player():
	return player_instance

func set_player(player):
	player_instance = player

func load_level(level_number: int):
	current_level = level_number
	var level_path = "res://scenes/levels/Level%d.tscn" % level_number
	get_tree().change_scene_to_file(level_path)

func next_level():
	if current_level < 5:
		load_level(current_level + 1)
	else:
		print("Jogo concluído! Voltando para a Fase 1...")
		load_level(1)
