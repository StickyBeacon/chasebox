extends Control
class_name CharacterSelect

var current_controllers = {}
@onready var menu = $"../.."
var can_select = false
var chosen_characters = {}


func _input(event: InputEvent) -> void:
	if !can_select:
		return
	
	for i in [1,2,3,4]:
		if event.is_action_pressed("shoot%s" % i) and not i in current_controllers.keys():
			current_controllers[i] = find_child("Card%s"%i)
			current_controllers[i].set_active(true)


func remove_player(id):
	if id not in current_controllers.keys():
		printerr("%s: %s not in current_controllers" % [name,id])
		return
	
	current_controllers[id].set_active(false)
	current_controllers.erase(id)


func attempt_start_game():
	
	var ready_to_play = true
	for card in current_controllers.values():
		if !card.ready_to_play:
			ready_to_play = false
			break
	
	if ready_to_play:
		if current_controllers.values().size()<2:
			print("%s: at least 2 players needed to start game" % name)
			return
		
		%CharacterSelection.add_characters()
		menu.start_game()
	else:
		print("%s: Not everyone is ready!" % name)
	

func clear_everything():
	for card in current_controllers.values():
		card.set_controller(-1)
	current_controllers.clear()


func choose_character(controller_id,character_id):
	if character_id in chosen_characters.values():
		return false
	
	chosen_characters[controller_id] = character_id
	return true
	

func deselect_character(controller_id):
	chosen_characters.erase(controller_id)


func add_characters():
	for controller_id in chosen_characters.keys():
		var character_id = chosen_characters[controller_id]
		PlayerManager.add_player(controller_id,character_id)
