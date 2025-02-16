extends Node2D

@onready var arena_scene = load("res://spaces/arena.tscn")

# Dit script zal zorgen voor welke UI's wanneer actief zijn
@onready var _current_ui :Control = %MainMenu:
	set(new_ui):
		if new_ui == null:
			printerr("This is null")
			return
		_current_ui.visible = false
		_current_ui = new_ui
		_current_ui.visible = true


func _ready() -> void:
	for child in $CanvasLayer.get_children():
		child.visible = false
	%MainMenu.visible = true


func change_menu(node_name:StringName):
	%TickSound.play()
	%BGMusicDrums.volume_db = -80
	%BGMusicChords.volume_db = -80
	_current_ui = %CanvasLayer.find_child(node_name)
	%CharacterSelection.clear_everything()
	%CharacterSelection.can_select = false
	if _current_ui == %CharacterSelection:
		%BGMusicChords.volume_db = -10
		%BGMusicDrums.volume_db = -10
		%CharacterSelection.can_select = true
	elif _current_ui == %StartGame:
		%BGMusicDrums.volume_db = -10
 

func _on_quit_button_button_up() -> void:
	%TickSound.play()
	print("bai bai!")
	get_tree().quit()


func start_game() -> void:
	GameSettings.rounds = %RoundCount.value
	get_tree().change_scene_to_packed(arena_scene)
