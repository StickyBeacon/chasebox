extends Node

var turn_count:int = 0
var round_count:int = 0
var max_round_count :int= 5
# Voor totale game score bij te houden
var game_score_dict = {}
# Voor momentele ronde score bij te houden
var round_score_dict = {}
var turn_order = []
# de spelers die gekozen worden, worden hierin toegevoegd. standaard op 1 en 2
var chosen_players = [1,2]

var team_chasers = []
var team_runners = []


func start_game():
	# check hoeveel spelers er zijn
	# -> Laad UI, laad characters 
	
	# Reset alle in-game-bepaalde waarden
	reset_values()
	# Shuffle turn order voor dit spel
	turn_order = chosen_players.duplicate()
	turn_order.shuffle()
	next_round()


func next_round():
	round_count += 1
	# laad nieuwe map, bepaal gamemode
	turn_order.reverse()
	next_turn()
	pass
	

func next_turn():
	turn_count += 1
	#Als alle turns voorbij zijn, begin nieuwe "ronde"
	if turn_count > turn_order.size():
		turn_count = 0
		next_round()
		return
		
	var chosen_id = turn_order[turn_count-1]
	# zie de turn_dict, bepaal welke spelers chasers zijn en welke runners
	
	pass
	
	
func reset_values():
	turn_count = 0
	round_count = 0
	turn_order = []
	game_score_dict = {}
	round_score_dict = {}


func player_died(player):
	
	pass
