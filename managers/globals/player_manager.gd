extends Node

@onready var player_scene = preload("res://player/player.tscn")
var player_dict = {}


func add_player(controller_id,player_id, saw_size = 1, speed = 1.15): # zou ook extra info kunnen bevatten (welke items)
	if player_dict.keys().has(player_id):
		printerr("%s: player id %s bestaat al in dict!" % [name, player_id])
		return
	elif not player_id in [1,2,3,4]:
		printerr("%s: %s is geen geldig playerid" % [name, player_id])
		return
	
	var new_player :Player = player_scene.instantiate()
	new_player.player_id = player_id
	new_player.controller_id = controller_id
	new_player.enabled = false
	new_player.mult_saw_size(saw_size)
	new_player.mult_chaser_speed(speed)
	# Insert hier extra dingen met de items en andere options (handicaps?)
	player_dict[player_id] = new_player
	


func clear_players():
	for child in get_children():
		child.queue_free()
		
	player_dict = {}


func get_player(id):
	if not id in player_dict.keys():
		printerr("%s: %s niet in playerdict" % [name, id])
		return null
	return player_dict[id]


func toggle_all_players(value):
	for id in player_dict.keys():
		player_dict[id].enabled = value


func toggle_player(id, value):
	player_dict[id].enabled = value


func reset_players():
	for id in player_dict:
		player_dict[id].velocity = Vector2.ZERO


func spawn_players():
	for player in player_dict.values():
		if player.get_parent(): return
		
		add_child(player)
		player.position = Vector2(0,0)


func is_empty():
	return player_dict.is_empty()
