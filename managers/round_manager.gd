extends Node
class_name RoundManager

var turn_count:int = 0
var round_count:int = 0
var max_round_count :int= 5
var turn_order = []
# de spelers die gekozen worden, worden hierin toegevoegd. standaard op 1 en 2
var chosen_players = []
# 0 is chasers, 1 is runners
var team_dict = {Utils.Team.Chaser: [], Utils.Team.Runner: []}
var current_gamemode:Utils.GameMode = Utils.GameMode.Hunter


func _input(event: InputEvent) -> void: #TODO temporary match start shortcut
	if event.is_action_pressed("ui_focus_next"):
		chosen_players = [1,2]
		for id in chosen_players:
			%PlayerManager.add_player(id)
		start_game()


# Voor het zetten van de spelers, max round count etc. 
func set_game_values(player_array:Array, new_round_count:int):
	chosen_players = player_array
	max_round_count = new_round_count
	pass


func start_game():
	#TODO inladen van UI en characters op basis van de gekozen spelers
	print("%s: Starting game" % name)
	# Reset alle in-game-bepaalde waarden
	reset_values()
	initialize_values()
	# Shuffle turn order voor dit spel
	turn_order = chosen_players.duplicate()
	turn_order.shuffle()
	next_round()


func next_round():
	print("%s: next round" % name)
	round_count += 1
	clear_round()
	
	if round_count > max_round_count:
		end_game()
		return

	%MapManager.generate_random_map()
	current_gamemode = Utils.GameMode.values().pick_random()
	turn_order.reverse()
	next_turn()
	pass
	

func next_turn():
	turn_count += 1
	print("%s: turn %s round %s" % [name, turn_count, round_count])
	%PlayerManager.reset_players()
	clear_turn()
	#Als alle turns voorbij zijn, begin nieuwe "ronde"
	if turn_count > turn_order.size():
		%TimerManager.calculate_round_points()
		turn_count = 0
		next_round()
		return
		
	var chosen_id = turn_order[turn_count-1]
	
	# Enkel de Hunter gamemode for now
	team_dict[Utils.Team.Chaser].append(chosen_id)
	for player_id in chosen_players:
		if player_id == chosen_id: continue
		team_dict[Utils.Team.Runner].append(player_id)
	
	#match(current_gamemode): TODO gamemodes?
		#Utils.GameMode.Hunter:
			#team_dict[Utils.Team.Chaser].append(chosen_id)
			#for player_id in chosen_players:
				#if player_id == chosen_id: continue
				#team_dict[Utils.Team.Runner].append(player_id)
		#Utils.GameMode.Prey:
			#team_dict[Utils.Team.Runner].append(chosen_id)
			#for player_id in chosen_players:
				#if player_id == chosen_id: continue
				#team_dict[Utils.Team.Chaser].append(player_id)
	
	
	# TODO maak maps bruh
	# Initialize player variables based on team
	%PlayerManager.toggle_all_players(false)
	%MapManager.spawn_players(team_dict)
	# Game starts
	await wait(.3) #TODO maak het hier duidelijk wie waar spawnt? idk man
	%TimerManager.start_timer()
	
	%PlayerManager.toggle_all_players(true)


func reset_values():
	turn_count = 0
	round_count = 0
	turn_order = []
	team_dict = {Utils.Team.Chaser: [], Utils.Team.Runner: []}


func initialize_values():
	for player_id in chosen_players:
		var player :Player = %PlayerManager.get_player(player_id)
		%TimerManager.add_player(player_id)
		if !player.player_died.is_connected(on_player_died):
			player.player_died.connect(on_player_died)
		


func on_player_died(player_id):
	var player :Player= %PlayerManager.get_player(player_id)
	team_dict[player.team].erase(player_id)
	if player.team == Utils.Team.Runner:
		%TimerManager.add_player_time(player_id)
		#TODO Momenteel enkel geprogrammeerd voor 2 players
		# Players worden dus niet verwijdert als ze sterven. Gewoon verplaatst.
	
	# Een team is volledig dood
	if team_dict[player.team].size() == 0:
		end_turn()
		
	elif player.team == Utils.Team.Chaser: #Speler is chaser en andere chaser leeft nog
		printerr("%s: loser alert. Een chaser is gestorven? Bruh" % name)


func clear_turn(): # TODO Hier ook iets te doen met time? denkik?
	team_dict = {Utils.Team.Chaser: [], Utils.Team.Runner: []}


func clear_round():
	%TimerManager.clear_round()


func _on_round_timer_timeout() -> void:
	for id in team_dict[Utils.Team.Runner]:
		%TimerManager.add_player_time(id, true)
		end_turn()


func end_turn():
	#TODO Toon hier de freeze en wat er gebeurt?
	get_tree().paused = true
	%IngameUIManager.toggle_turn_ui(true, "booger,s")
	await wait(1)
	%IngameUIManager.toggle_turn_ui(false)
	get_tree().paused = false
	%PlayerManager.toggle_all_players(false)
	%TimerManager.reset_timer()
	next_turn()


func end_game():
	#TODO end game. show score. show total time. Options: menu, again
	%PlayerManager.toggle_all_players(false)
	%TimerManager.display_end_scores()
	

func restart_game():
	#TODO eigenlijk gewoon game start zonder dat allerlei waardes worden aangepast
	pass


func wait(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout
