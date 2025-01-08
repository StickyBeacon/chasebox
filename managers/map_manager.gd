extends Node

var _map_list = []
const MAP_DIR = "res://spaces/maps/"
var _current_map :BaseMap= null


func _ready() -> void:
	var dir_access = DirAccess.open(MAP_DIR)
	for map in dir_access.get_files():
		if map.ends_with(".tscn"):
			_map_list.append(load(MAP_DIR + map))


func generate_random_map():
	clear_map()
	var new_map = _map_list.pick_random().instantiate()
	%Map.add_child(new_map)
	_current_map = new_map
	


func spawn_players(team_dict):
	for id in team_dict[RoundManager.Team.Chaser] + team_dict[RoundManager.Team.Runner]:
		var team = RoundManager.Team.Chaser if id in team_dict[RoundManager.Team.Chaser] else RoundManager.Team.Runner
		var player :Player= %PlayerManager.get_player(id)
		player.is_chaser = true if team == RoundManager.Team.Chaser else false
		player.global_position = _current_map.get_spawn(team)
	


func clear_map():
	_current_map = null
	for child in %Map.get_children():
		child.queue_free()
