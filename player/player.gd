extends CharacterBody2D
class_name Player

@export var is_player_1 :bool = true


func get_player_id():
	return 1 if is_player_1 else 2


func hit_player(object):
	print("%s got hit by %s" % [name, object.name]) 
