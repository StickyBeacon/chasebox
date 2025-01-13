extends Node2D

const ARENA_SCENE = preload("res://spaces/arena.tscn")
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
	_current_ui = %CanvasLayer.find_child(node_name)
	%CharacterSelection.clear_everything()
	%CharacterSelection.can_select = false
	if _current_ui == %CharacterSelection:
		%CharacterSelection.can_select = true
	pass


func _on_quit_button_button_up() -> void:
	print("bai bai!")
	get_tree().quit()


func start_game() -> void:
	GameSettings.rounds = %RoundCount.value
	get_tree().change_scene_to_packed(ARENA_SCENE)
