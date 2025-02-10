extends VBoxContainer


func set_players(order:Array, time_dict):
	var current_icons = []
	for child in get_children():
		child.visible = false
		
	
	for i in range(order.size()):
		var icon :TextureRect= find_child(str(order[i]))
		move_child(icon, i)
		icon.visible = true
		current_icons.append(icon)
		icon.modulate = Color(1,1,1)
		
		icon.get_child(0).text = "%.2f" % time_dict[order[i]]
