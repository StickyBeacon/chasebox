extends VBoxContainer

var controller_id :int = -1

var selectable_objects = ["PlayerIcon", "Handicap", "ReadyColor", "Quit"]
var hover_index = 0:
	set(value):
		hover_index = value % 4


func _input(event: InputEvent) -> void:
	if not controller_id in [1,2,3,4]:
		return
	
	if event.is_action_pressed("down%s" % controller_id):
		hover_index += 1
		hover_to(selectable_objects[hover_index])
	
	if event.is_action_pressed("jump%s" % controller_id) or event.is_action_pressed("shoot%s" % controller_id):
		activate(selectable_objects[hover_index])
	
	if event.is_action_pressed("right%s"% controller_id):
		scroll(selectable_objects[hover_index], 1)
	
	if event.is_action_pressed("left%s"% controller_id):
		scroll(selectable_objects[hover_index], 1)


func activate(item):
	match(item):
		"PlayerIcon":
			#TODO claim player icon
			pass
		"Handicap":
			#TODO claim handicap
			pass
		"ReadyColor":
			#TODO ready/unready
			pass
		"Quit":
			#TODO remove player
			pass
		_:
			printerr("%s: item %s does not exist" % item)


func hover_to(item):
	item.modulate = Color(1,1,1,0.5)


func scroll(item,dir:int):
	match(item):
		"PlayerIcon":
			#TODO next/previous player icon
			pass
		"Handicap":
			#TODO next/previous handicap
			pass
		"ReadyColor":
			#TODO nothing
			pass
		"Quit":
			#TODO nothing
			pass
		_:
			printerr("%s: item %s does not exist" % item)
