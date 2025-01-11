extends Node

var rounds :int= 3:
	set(round):
		rounds = round
	
var gamemode_list :Array= [Utils.GameMode.Hunter]


func add_gamemode(gamemode :Utils.GameMode):
	gamemode_list.append(gamemode)


func clear_gamemodes():
	gamemode_list.clear()
