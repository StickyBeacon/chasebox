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


# Voor het zetten van de spelers, max round count etc. 
func set_game_values(player_array:Array, round_count:int):
	chosen_players = player_array
	max_round_count = round_count
	pass


func start_game():
	#TODO inladen van UI en characters op basis van de gekozen spelers
	
	# Reset alle in-game-bepaalde waarden
	reset_values()
	initialize_values()
	# Shuffle turn order voor dit spel
	turn_order = chosen_players.duplicate()
	turn_order.shuffle()
	next_round()


func next_round():
	round_count += 1
	
	if round_count > max_round_count:
		#TODO end game. show score. show total time. Options: menu, again
		print("%s: Game ended" % name)
		return
	
	#TODO laad nieuwe map
	current_gamemode = GameMode.values().pick_random()
	turn_order.reverse()
	next_turn()
	pass
	

func next_turn():
	turn_count += 1
	#Als alle turns voorbij zijn, begin nieuwe "ronde"
	if turn_count > turn_order.size():
		calculate_round_points()
		turn_count = 0
		next_round()
		return
		
	var chosen_id = turn_order[turn_count-1]

	match(current_gamemode):
		GameMode.Hunter:
			team_dict[Team.Chaser].append(chosen_id)
			for player_id in chosen_players:
				if player_id == chosen_id: continue
				team_dict[Team.Runner].append(player_id)
		GameMode.Prey:
			team_dict[Team.Runner].append(chosen_id)
			for player_id in chosen_players:
				if player_id == chosen_id: continue
				team_dict[Team.Chaser].append(player_id)
	# TODO
	# Spawn alle runners in runner plekken
	# Spawn alle chasers in chaser plekken
	
	
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
		game_score_dict[player_id] = 0
		round_time_dict[player_id] = 0
		total_time_dict[player_id] = 0


func player_died(player:Player):
	team_dict[int(player.is_chaser)].erase(player.player_id)
	if !player.is_chaser:
		#TODO stop timer, & save to turn_score_dict
		#add_round_time(player)
		pass
	
	# Een team is volledig dood
	if team_dict[int(player.is_chaser)].size() == 0:
		#TODO Freeze game, toon wat er gebeurt is
		
		next_turn()
	elif player.is_chaser: #Speler is chaser en andere chaser leeft nog
		print("%s: loser alert. Een chaser is gestorven? Bruh" % name)


func add_round_time(player_id, time):
	#TODO momenteel is dit gebaseerd op totale tijd.
	# Als een speler dus een keer 20 seconden overleeft is er een grote
	# kans dat hij gaat winnen
	
	if team_dict[Team.Chaser].has(player_id):
		printerr("%s: Chasers hebben geen timer om te scoren!" % name)
	
	round_time_dict[player_id] += time
	total_time_dict[player_id] += time


func calculate_round_points():
	#TODO Momenteel neemt het gewoon de max. Het gaat ervanuit dat er maar 1 max is
	# Spelers kunnen tie-en :(
	
	var values = round_time_dict.values()
	var player_id = round_time_dict.keys()[values.find(max(values))]
	
	game_score_dict[player_id] += 1
