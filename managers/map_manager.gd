extends Node


func generate_random_map():
	pass


func spawn_players():
	pass


func clear_map():
	for child in %Map.get_children():
		child.queue_free()
