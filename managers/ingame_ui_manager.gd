extends Node

func set_turn_ui(value:bool, _round  =-1, _turn=-1):
	%TurnAnouncer.visible = value
	%TurnAnouncerText.text = "Round: %s, Turn: %s" % [_round, _turn]
	%TurnIndicator.visible = value
