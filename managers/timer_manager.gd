extends Node

@onready var timer :Timer = %ActualTimer
@onready var label :Label = %TimeLabel
# Voor totale game score bij te houden
var game_score_dict = {}
# Voor momentele ronde score bij te houden
var round_time_dict = {}
var total_time_dict = {}


func _physics_process(_delta: float) -> void:
	if !timer.is_stopped():
		label.text = "%.2f" % (timer.wait_time - timer.time_left)


func get_current_time():
	return (timer.wait_time - timer.time_left)
	

func reset_timer():
	label.text = "0"
	timer.stop()


func start_timer():
	timer.start()


func reset_values():
	game_score_dict = {}
	round_time_dict = {}
	total_time_dict = {}


func add_player(player_id):
	game_score_dict[player_id] = 0
	round_time_dict[player_id] = 0
	total_time_dict[player_id] = 0


func calculate_round_points():
	var values = round_time_dict.values()
	var player_id = round_time_dict.keys()[values.find(values.max())]
	print("%s: %s got point this round!" % [name, player_id])
	game_score_dict[player_id] += 1


func clear_round():
	for id in round_time_dict.keys():
		round_time_dict[id] = 0
	

func add_player_time(player_id, max = false):
	print("%s: %s survived %s" % [name, player_id, get_current_time()])
	if max:
		round_time_dict[player_id] += timer.wait_time
		total_time_dict[player_id] += timer.wait_time
		return
	round_time_dict[player_id] += get_current_time()
	total_time_dict[player_id] += get_current_time()
	

func display_end_scores():
	for id in total_time_dict.keys():
		print("%s: %s time is %s" % [name,id,total_time_dict[id]])
	
	var values = total_time_dict.values()
	var winner_id = total_time_dict.keys()[values.find(values.max())]
	print("%s: %s won!" % [name,winner_id])
