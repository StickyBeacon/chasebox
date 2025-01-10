extends Node
class_name RoundManager

var _turn_count:int = 0
var _round_count:int = 0
var _max_round_count :int= 2
var _turn_order = []
# de spelers die gekozen worden, worden hierin toegevoegd. standaard op 1 en 2
var _chosen_players = []
# 0 is chasers, 1 is runners
var _team_dict = {Utils.Team.Chaser: [], Utils.Team.Runner: []}
var _current_gamemode:Utils.GameMode = Utils.GameMode.Hunter


func _input(event: InputEvent) -> void: #TODO temporary match start shortcut
	if event.is_action_pressed("ui_focus_next"):
		_chosen_players = [1,2]
		for id in _chosen_players:
			%PlayerManager.add_player(id)
		start_game()


# Voor het zetten van de spelers, max round count etc. 
func set_game_values(player_array:Array, new_round_count:int):
	_chosen_players = player_array
	_max_round_count = new_round_count
	pass


func start_game():
	#TODO inladen van UI en characters op basis van de gekozen spelers
	print("%s: Starting game" % name)
	# Reset alle in-game-bepaalde waarden
	_reset_values()
	_initialize_values()
	# Shuffle turn order voor dit spel
	_turn_order = _chosen_players.duplicate()
	_turn_order.shuffle()
	_next_round()


func _next_round():
	print("%s: next round" % name)
	_round_count += 1
	_clear_round()
	
	if _round_count > _max_round_count:
		_end_game()
		return

	%MapManager.generate_random_map()
	_current_gamemode = Utils.GameMode.values().pick_random()
	_turn_order.reverse()
	_next_turn()
	pass
	

func _next_turn():
	_turn_count += 1
	print("%s: turn %s round %s" % [name, _turn_count, _round_count])
	%PlayerManager.reset_players()
	_clear_turn()
	#Als alle turns voorbij zijn, begin nieuwe "ronde"
	if _turn_count > _turn_order.size():
		%TimerManager.calculate_round_points()
		_turn_count = 0
		_next_round()
		return
	
	# Current Turn overview
	get_tree().paused = true
	%TurnIndicator.set_players(_turn_order,_turn_count)
	%IngameUIManager.set_turn_ui(true, _round_count ,_turn_count)
	await _wait(1)
	%IngameUIManager.set_turn_ui(false)
	get_tree().paused = false
	
	
	var chosen_id = _turn_order[_turn_count-1]
	
	# Enkel de Hunter gamemode for now
	_team_dict[Utils.Team.Chaser].append(chosen_id)
	for player_id in _chosen_players:
		if player_id == chosen_id: continue
		_team_dict[Utils.Team.Runner].append(player_id)
	
	#match(_current_gamemode): #TODO gamemodes?
		#Utils.GameMode.Hunter:
			#_team_dict[Utils.Team.Chaser].append(chosen_id)
			#for player_id in _chosen_players:
				#if player_id == chosen_id: continue
				#_team_dict[Utils.Team.Runner].append(player_id)
		#Utils.GameMode.Prey:
			#_team_dict[Utils.Team.Runner].append(chosen_id)
			#for player_id in _chosen_players:
				#if player_id == chosen_id: continue
				#_team_dict[Utils.Team.Chaser].append(player_id)
	
	
	# TODO maak maps bruh
	# Initialize player variables based on team
	%PlayerManager.toggle_all_players(false)
	%MapManager.spawn_players(_team_dict)
	# Game starts
	await _wait(.3) #TODO maak het hier duidelijk wie waar spawnt? idk man
	%TimerManager.start_timer()
	
	%PlayerManager.toggle_all_players(true)


func _reset_values():
	_turn_count = 0
	_round_count = 0
	_turn_order = []
	_team_dict = {Utils.Team.Chaser: [], Utils.Team.Runner: []}
	%EndScreen.visible = false


func _initialize_values():
	for player_id in _chosen_players:
		var player :Player = %PlayerManager.get_player(player_id)
		%TimerManager.add_player(player_id)
		if !player.player_died.is_connected(on_player_died):
			player.player_died.connect(on_player_died)
		


func on_player_died(player_id):
	var player :Player= %PlayerManager.get_player(player_id)
	_team_dict[player.team].erase(player_id)
	if player.team == Utils.Team.Runner:
		%TimerManager.add_player_time(player_id)
		#TODO Momenteel enkel geprogrammeerd voor 2 players
		# Players worden dus niet verwijdert als ze sterven. Gewoon verplaatst.
	
	# Een team is volledig dood
	if _team_dict[player.team].size() == 0:
		_end_turn()
		
	elif player.team == Utils.Team.Chaser: #Speler is chaser en andere chaser leeft nog
		printerr("%s: loser alert. Een chaser is gestorven? Bruh" % name)


func _clear_turn(): # TODO Hier ook iets te doen met time? denkik?
	_team_dict = {Utils.Team.Chaser: [], Utils.Team.Runner: []}


func _clear_round():
	%TimerManager.clear_round()


func _on_round_timer_timeout() -> void:
	for id in _team_dict[Utils.Team.Runner]:
		%TimerManager.add_player_time(id, true)
		_end_turn()


func _end_turn():
	#TODO Toon hier de freeze en wat er gebeurt?
	get_tree().paused = true
	await _wait(.2)
	get_tree().paused = false
	%PlayerManager.toggle_all_players(false)
	%TimerManager.reset_timer()
	_next_turn()


func _end_game():
	#TODO end game. show score. show total time. Options: menu, again
	%PlayerManager.toggle_all_players(false)
	
	%TimerManager.display_end_scores()
	%EndScreen.visible = true

func restart_game():
	#TODO eigenlijk gewoon game start zonder dat allerlei waardes worden aangepast
	pass


func _wait(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout
