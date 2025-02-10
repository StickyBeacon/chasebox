extends Node

@onready var timer :Timer = %ActualTimer
@onready var label :Label = %TimeLabel
var total_time_dict = {}
const SURVIVED_ADDITION = 5


func _physics_process(_delta: float) -> void:
	if !timer.is_stopped():
		label.text = "%.2f" % (timer.wait_time - timer.time_left)


func _get_current_time():
	return (timer.wait_time - timer.time_left)
	

func reset_timer():
	label.text = "0"
	timer.stop()
	%TickTockSound.stop()


func start_timer():
	timer.start()
	%TickTockSound.play()


var pause_position = null
func pause_tick_tock():
	pause_position = %TickTockSound.get_playback_position()
	%TickTockSound.stop()


func continue_tick_tock():
	%TickTockSound.play(pause_position)


func reset_values():
	total_time_dict = {}


func add_player(player_id):
	total_time_dict[player_id] = 0


func add_player_time(player_id, max_time = false):
	print("%s: %s survived %s" % [name, player_id, _get_current_time()])
	if max_time:
		total_time_dict[player_id] += timer.wait_time + SURVIVED_ADDITION
		return
	total_time_dict[player_id] += _get_current_time()
	

func display_end_scores():
	for id in total_time_dict.keys():
		print("%s: %s time is %s" % [name,id,total_time_dict[id]])
	
	var values = total_time_dict.values()
	var winner_id = total_time_dict.keys()[values.find(values.max())]
	print("%s: %s won!" % [name,winner_id])
	
	var order_array = []
	var value_ordered = total_time_dict.values()
	value_ordered.sort()
	value_ordered.reverse()
	for i in value_ordered.size():
		var value = value_ordered[i]
		for key in total_time_dict.keys():
			if total_time_dict[key] == value and key not in order_array:
				order_array.append(key)
	%EndScreenList.set_players(order_array,total_time_dict)

	
