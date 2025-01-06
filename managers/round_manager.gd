extends Node
class_name RoundManager

var turn_count:int = 0
var round_count:int = 0
var max_round_count :int= 5
# Voor totale game score bij te houden
var game_score_dict = {}
# Voor momentele ronde score bij te houden
var round_time_dict = {}
var total_time_dict = {}
var turn_order = []
# de spelers die gekozen worden, worden hierin toegevoegd. standaard op 1 en 2
var chosen_players = [1,2]
# 0 is chasers, 1 is runners
var team_dict = {Team.Chaser: [], Team.Runner: []}
var current_gamemode:GameMode = GameMode.Hunter

enum Team {
	Chaser,
	Runner
}

enum GameMode {
	Hunter, # 1 Chaser, de rest runners. Basic gamemode.
	Prey # 1 Runner, de rest chasers. De enge gamemode.
}


func _input(event: InputEvent) -> void: #TODO temporary match start shortcut
	if event.is_action_pressed("ui_focus_next"):
		%PlayerManager.add_player(1)
		%PlayerManager.add_player(2)
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
	
	#TODO laad nieuwe map
	current_gamemode = GameMode.values().pick_random()
	turn_order.reverse()
	next_turn()
	pass
	

func next_turn():
	turn_count += 1
	print("%s: turn %s round %s" % [name, turn_count, round_count])
	clear_turn()
	#Als alle turns voorbij zijn, begin nieuwe "ronde"
	if turn_count > turn_order.size():
		calculate_round_points()
		turn_count = 0
		next_round()
		return
		
	var chosen_id = turn_order[turn_count-1]
	
	# Enkel de Hunter gamemode for now
	team_dict[Team.Chaser].append(chosen_id)
	for player_id in chosen_players:
		if player_id == chosen_id: continue
		team_dict[Team.Runner].append(player_id)
	
	#match(current_gamemode): TODO gamemodes?
		#GameMode.Hunter:
			#team_dict[Team.Chaser].append(chosen_id)
			#for player_id in chosen_players:
				#if player_id == chosen_id: continue
				#team_dict[Team.Runner].append(player_id)
		#GameMode.Prey:
			#team_dict[Team.Runner].append(chosen_id)
			#for player_id in chosen_players:
				#if player_id == chosen_id: continue
				#team_dict[Team.Chaser].append(player_id)
	
	
	# TODO maak maps bruh
	# Initialize player variables based on team
	var run_spawn = Vector2(-400,-200) # temp
	var chase_spawn = Vector2(400,200) # temp
	for id in chosen_players:
		var player :Player= %PlayerManager.get_player(id)
		player.is_chaser = true if id in team_dict[Team.Chaser] else false
		player.global_position = chase_spawn if id in team_dict[Team.Chaser] else run_spawn
	
	# Game starts
	%PlayerTimer.start_timer()


func reset_values():
	turn_count = 0
	round_count = 0
	turn_order = []
	game_score_dict = {}
	round_time_dict = {}
	total_time_dict = {}
	team_dict = {Team.Chaser: [], Team.Runner: []}


func initialize_values():
	for player_id in chosen_players:
		var player :Player = %PlayerManager.get_player(player_id)
		game_score_dict[player_id] = 0
		round_time_dict[player_id] = 0
		total_time_dict[player_id] = 0
		if !player.player_died.is_connected(on_player_died):
			player.player_died.connect(on_player_died)
		


func on_player_died(player_id):
	var player :Player= %PlayerManager.get_player(player_id)
	team_dict[player.get_team()].erase(player_id)
	if !player.is_chaser:
		add_round_time(player_id,%PlayerTimer.get_current_time())
		pass
	
	# Een team is volledig dood
	if team_dict[player.get_team()].size() == 0:
		end_turn()
	elif player.is_chaser: #Speler is chaser en andere chaser leeft nog
		printerr("%s: loser alert. Een chaser is gestorven? Bruh" % name)


func add_round_time(player_id, time):
	if team_dict[Team.Chaser].has(player_id):
		printerr("%s: Chasers hebben geen timer om te scoren!" % name)
	
	print("%s: %s survived %s" % [name, player_id, time])
	round_time_dict[player_id] += time
	total_time_dict[player_id] += time


func calculate_round_points():
	#TODO Momenteel neemt het gewoon de max. Het gaat ervanuit dat er maar 1 max is
	# Spelers kunnen tie-en :(
	
	var values = round_time_dict.values()
	var player_id = round_time_dict.keys()[values.find(values.max())]
	print("%s: %s got point this round!" % [name, player_id])
	game_score_dict[player_id] += 1
	

func clear_turn(): # TODO Hier ook iets te doen met time? denkik?
	team_dict = {Team.Chaser: [], Team.Runner: []}


func clear_round():
	for id in round_time_dict.keys():
		round_time_dict[id] = 0


func _on_round_timer_timeout() -> void:
	for id in team_dict[Team.Runner]:
		add_round_time(id,%ActualTimer.wait_time)
		end_turn()


func end_turn():
	#TODO Toon hier de freeze en wat er gebeurt?
	%PlayerTimer.reset_timer()
	next_turn()


func end_game():
	#TODO end game. show score. show total time. Options: menu, again
	for id in total_time_dict.keys():
		print("%s: %s time is %s" % [name,id,total_time_dict[id]])
	
	var values = total_time_dict.values()
	var player_id = total_time_dict.keys()[values.find(values.max())]
	print("%s: %s won!" % [name,player_id])
	
