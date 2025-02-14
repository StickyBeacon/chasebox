extends VBoxContainer

@export var controller_id :int = -1 #TODO verander dit
var active:bool = false

var selectable_objects = ["PlayerIcon", "SawSize","Speed", "ReadyColor", "Quit", "Start"]
var hover_index = 0:
	set(value):
		hover_index = posmod(value,selectable_objects.size())

var icon_dict = {0:preload("res://assets/images/WaveIcon.png"),1:preload("res://assets/images/BratIcon.png"),2:preload("res://assets/images/QueenIcon.png"),3:preload("res://assets/images/JuliettIcon.png")}
var icon_scroll_index = 0:
	set(value):
		icon_scroll_index = posmod(value,icon_dict.size())
		%PlayerIcon.texture = icon_dict[icon_scroll_index]

var saw_size_scroll_index = 0:
	set(value):
		saw_size_scroll_index = posmod(value, saw_size_array.size())
		%SawSizeLabel.text = str(saw_size_array[saw_size_scroll_index])
var saw_size_array:Array = [1.0,1.5,2.0,3.0,0.1,0.25,0.5,0.75] 

var speed_scroll_index = 0:
	set(value):
		speed_scroll_index = posmod(value, speed_array.size())
		%SpeedLabel.text = str(speed_array[speed_scroll_index])
var speed_array:Array = [1.15,1.30,1.5,1.75,2,0.5,0.75,0.80,0.85,0.90,0.95,1.0,1.05,1.1]

var ready_to_play :bool= false
var character_select:CharacterSelect = null

var has_chosen_character = false
var has_chosen_saw_size = false
var has_chosen_speed = false


func _ready() -> void:
	%NameLabel.text = "Player %s" % controller_id
	%SawSizeLabel.text = str(saw_size_array[saw_size_scroll_index])
	%SpeedLabel.text = str(speed_array[speed_scroll_index])
	character_select = get_parent() #TODO hihihihihihihi
	visible = false
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
			if ready_to_play: return
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
		"SawSize":
			if ready_to_play: return
			# choose sawsize
			if !has_chosen_saw_size: 
				character_select.choose_saw_size(controller_id,saw_size_array[saw_size_scroll_index])
				has_chosen_saw_size = true
				%SawSize.modulate = Color(1,1,0)
			else:
				character_select.choose_saw_size(controller_id,-1) # hahaha
				has_chosen_saw_size = false
				%SawSize.modulate = Color(1,1,1)
			pass
		"Speed":
			if ready_to_play: return
			# choose speed
			if !has_chosen_speed: 
				character_select.choose_speed(controller_id,speed_array[speed_scroll_index])
				has_chosen_speed = true
				%Speed.modulate = Color(1,1,0)
			else:
				character_select.choose_speed(controller_id,-1) # baaa
				has_chosen_speed = false
				%Speed.modulate = Color(1,1,1)
			pass
		"ReadyColor":
			# ready/unready
			if !has_chosen_character or !has_chosen_saw_size or !has_chosen_speed: return
			
			ready_to_play = !ready_to_play
			if (ready_to_play):
				%ReadyColor.modulate = Color(0,1,0)
				%ReadyLabel.text = "Ready"
			else:
				%ReadyColor.modulate = Color(1,0,0)
				%ReadyLabel.text = "Not ready"
		"Quit":
			if ready_to_play: return
			
			character_select.remove_player(controller_id)
		"Start":
			# start the game
			character_select.attempt_start_game()
		_:
			printerr("%s: item %s does not exist" % item)


func hover_to(item_name):
	for child in get_children():
		child.modulate.v = .6
	
	var item = find_child(item_name)
	if item:
		item.modulate.v = 1


func scroll(item,dir:int):
	match(item):
		"PlayerIcon":
			if has_chosen_character: return
			icon_scroll_index += dir
			
		"SawSize":
			if has_chosen_saw_size: return
			saw_size_scroll_index += dir
			
			pass
		"Speed":
			if has_chosen_speed: return
			speed_scroll_index += dir
			
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
	
