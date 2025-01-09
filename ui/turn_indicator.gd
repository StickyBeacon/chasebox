extends HBoxContainer


func set_players(order:Array, turn_numb):
	var current_icons = []
	for child in get_children():
		child.visible = false
		
	
	for i in range(order.size()):
		var icon :TextureRect= find_child(str(order[i]))
		move_child(icon, i)
		icon.visible = true
		current_icons.append(icon)
		icon.modulate = Color(.2,.2,.2)
	
	current_icons[turn_numb-1].modulate = Color(1,1,1)
