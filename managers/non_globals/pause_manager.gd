extends Node

var is_paused = false
const MAIN_MENU_PATH = "res://spaces/main_menu.tscn"


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("menu"):
		if not %RoundManager.is_in_game: return
		
		toggle_pause()


func toggle_pause():
	is_paused = !is_paused
	%PauseScreen.visible = is_paused
	if is_paused:
		print("pausng!")
		%TimerManager.pause_tick_tock()
		
	get_tree().paused = is_paused
	if !is_paused:
		%TimerManager.continue_tick_tock()
	


func _on_continue_button_up() -> void:
	toggle_pause()


func _on_quit_button_up() -> void:
	toggle_pause()
	PlayerManager.clear_players()
	get_tree().change_scene_to_file(MAIN_MENU_PATH)
