extends Node

const MAP_DIR = "res://spaces/maps/"
var _current_map :BaseMap= null
var _chosen_maps = [1,2,3,4,5]
var _current_maps = []
var _current_map_id = -1


func _ready() -> void:
	set_maps(_chosen_maps)


func generate_random_map():
	_clear_map()
	
	if _current_maps.is_empty():
		set_maps(_chosen_maps)
	
	_current_map_id = _current_maps.pick_random()
	print("%s: loading map %s" % [name,_current_map_id])
	var map_to_load = ResourceLoader.load("res://spaces/maps/map_%s.tscn" % _current_map_id)
	var new_map = map_to_load.instantiate()
	%Map.add_child(new_map)
	_current_map = new_map
	_current_maps.erase(_current_map_id)


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


func set_maps(maps):
	_chosen_maps = maps
	_current_maps = _chosen_maps.duplicate()
