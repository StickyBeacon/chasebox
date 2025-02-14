extends Sprite2D


func initialize(color, pos):
	global_position = pos
	modulate = color
	rotation = randf_range(-PI,PI)
	var random_scale = randf_range(0.5,1.75)
	scale = Vector2(random_scale * randf_range(0.8,1.2),random_scale * randf_range(0.8,1.2))
	global_position.x += randf_range(-50,50)
	global_position.x += randf_range(-50,50)
