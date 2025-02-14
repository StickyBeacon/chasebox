extends Area2D


func _on_body_entered(body: Node2D) -> void:
	var player:Player = body
	if player.team == Utils.Team.Runner:
		player.hit_player(self)
