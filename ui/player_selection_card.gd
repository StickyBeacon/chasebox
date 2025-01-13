extends VBoxContainer

@export var controller_id :int = -1 #TODO verander dit
var active:bool = false

var selectable_objects = ["PlayerIcon", "Handicap", "ReadyColor", "Quit", "Start"]
var hover_index = 0:
	set(value):
		hover_index = posmod(value,selectable_objects.size())

var icon_dict = {0:preload("res://assets/images/WaveIcon.png"),1:preload("res://assets/images/BratIcon.png"),2:preload("res://assets/images/QueenIcon.png"),3:preload("res://assets/images/JuliettIcon.png")}
var icon_scroll_index = 0:
	set(value):
		icon_scroll_index = posmod(value,icon_dict.size())
		%PlayerIcon.texture = icon_dict[icon_scroll_index]

var handicap_scroll_index = 0:
	set(value):
		handicap_scroll_index = posmod(value, handicap_dict.keys().size())
		%HandiCapLabel.text = str(handicap_dict[handicap_scroll_index])
var handicap_dict:Dictionary = {}
var ready_to_play :bool= false
var character_select:CharacterSelect = null

var has_chosen_character = false
var has_chosen_handicap = false


func _ready() -> void:
	%NameLabel.text = "Player %s" % controller_id
	character_select = get_parent() #TODO hihihihihihihi
	visible = false
	# Initialize Handicap dict.
	for i in range(Utils.Handicap.keys().size()):
		handicap_dict[i] = Utils.Handicap.keys()[i]
	hover_to(selectable_objects[hover_index])


func _input(event: InputEvent) -> void:
	if not controller_id in [1,2,3,4] or !active:
		return
	
	if event.is_action_pressed("down%s" % controller_id):
		hover_index += 1
		hover_to(selectable_objects[hover_index])
	
	if event.is_action_pressed("up%s" % controller_id):
		hover_index -= 1
		hover_to(selectable_objects[hover_index])
	
	if event.is_action_pressed("jump%s" % controller_id):
		activate(selectable_objects[hover_index])
	
	if event.is_action_pressed("right%s"% controller_id):
		scroll(selectable_objects[hover_index], 1)
	
	if event.is_action_pressed("left%s"% controller_id):
		scroll(selectable_objects[hover_index], -1)


func activate(item):
	match(item):
		"PlayerIcon":
			# claim player icon
			if !has_chosen_character: 
				if character_select.choose_character(controller_id,icon_scroll_index+1):
					has_chosen_character = true
					%PlayerIcon.modulate = Color(1,1,0)
				else:
					print("%s: character has already been chosen" % name)
			else:
				character_select.deselect_character(controller_id)
				has_chosen_character = false
				%PlayerIcon.modulate = Color(1,1,1)
		"Handicap":
			# choose handicap
			if !has_chosen_handicap: 
				#TODO select handicap
				has_chosen_handicap = true
				%Handicap.modulate = Color(1,1,0)
			else:
				#TODO unselect handicap
				has_chosen_handicap = false
				%Handicap.modulate = Color(1,1,1)
			pass
		"ReadyColor":
			# ready/unready
			if !has_chosen_character or !has_chosen_handicap: return
			
			ready_to_play = !ready_to_play
			if (ready_to_play):
				%ReadyColor.modulate = Color(0,1,0)
				%ReadyLabel.text = "Ready"
			else:
				%ReadyColor.modulate = Color(1,0,0)
				%ReadyLabel.text = "Not ready"
		"Quit":
			character_select.remove_player(controller_id)
		"Start":
			# start the game
			character_select.attempt_start_game()
		_:
			printerr("%s: item %s does not exist" % item)


func hover_to(item_name):
	for child in get_children():
		child.modulate.a = 1 
	
	var item = find_child(item_name)
	if item:
		item.modulate.a = .8


func scroll(item,dir:int):
	match(item):
		"PlayerIcon":
			if has_chosen_character: return
			icon_scroll_index += dir
			
		"Handicap":
			if has_chosen_handicap: return
			handicap_scroll_index += dir
			
			pass
		"ReadyColor":
			# nothing
			pass
		"Quit":
			# nothing
			pass
		"Start":
			# nothing
			pass
		_:
			printerr("%s: item %s does not exist" % item)


func set_active(value:bool):
	active = value
	visible = active
	if !active: reset_values()


func reset_values():
	ready_to_play = false
	%ReadyColor.modulate = Color(1,0,0)
	%ReadyLabel.text = "Not ready"
	
