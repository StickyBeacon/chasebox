extends Node

@onready var player_scene = preload("res://player/player.tscn")
var player_dict = {}


func add_player(player_id): # zou ook extra info kunnen bevatten (welke items)
	if player_dict.keys().has(player_id):
		printerr("%s: player id %s bestaat al in dict!" % [name, player_id])
		return
	elif not player_id in [1,2,3,4]:
		printerr("%s: %s is geen geldig playerid" % [name, player_id])
	
	var new_player :Player = player_scene.instantiate()
	new_player.player_id = player_id
	
	# Insert hier extra dingen met de items en andere options (handicaps?)
	%PlayerNode.add_child(new_player)
	#TODO waar moeten de spelers naartoe als ze sterven?
	new_player.position = Vector2(0,0)
	player_dict[player_id] = new_player
	


func clear_players():
	player_dict = {}


func get_player(id):
	if not id in player_dict.keys():
		printerr("%s: %s niet in playerdict" % [name, id])
		return null
	return player_dict[id]
	
	
