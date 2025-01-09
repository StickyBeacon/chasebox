extends Node

func set_turn_ui(value:bool, text = ""):
	%TurnAnouncer.visible = value
	%TurnAnouncerText.text = text
