extends Node

@onready var player :CharacterBody2D = $"../.."
var input_dict = {"jump" = null,"shoot"= null,"left"= null,"right"= null,"up"= null,"down"= null}

var bullet_type = null


func _ready() -> void:
	var player_number = 1 if player.is_player_1 else 2
	
	for key in input_dict.keys():
		input_dict[key] = key + str(player_number)



func change_bullet_type(bullet):
	print("changed bullet type")
	bullet_type = bullet
