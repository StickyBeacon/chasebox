extends Node

var _map_list = []
const MAP_DIR = "res://spaces/maps/"
var _current_map :BaseMap= null
const MAPS = [1,2,3,4,5]


func _ready() -> void:
	var dir_access = DirAccess.open(MAP_DIR)
	for map in dir_access.get_files():
		if map.ends_with(".tscn"):
			_map_list.append(load(MAP_DIR + map))
			print("%s: added map %s" % [self,load(MAP_DIR + map)])


func generate_random_map():
	_clear_map()
	var map_to_load = ResourceLoader.load("res://spaces/maps/map_%s.tscn" % MAPS.pick_random())
	var new_map = map_to_load.instantiate()
	%Map.add_child(new_map)
	_current_map = new_map
	


func spawn_players(team_dict):
	for id in team_dict[Utils.Team.Chaser] + team_dict[Utils.Team.Runner]:
		var team = Utils.Team.Chaser if id in team_dict[Utils.Team.Chaser] else Utils.Team.Runner
		var player :Player= PlayerManager.get_player(id)
		player.team = team
		player.global_position = _current_map.get_spawn(team)
	


func _clear_map():
	_current_map = null
	for child in %Map.get_children():
		child.queue_free()
