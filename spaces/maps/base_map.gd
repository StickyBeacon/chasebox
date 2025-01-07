extends Node2D
class_name BaseMap

const RANDOM_ADDITION = 5


func get_spawn(team:RoundManager.Team):
	var variance_vector = Vector2(randf_range(-RANDOM_ADDITION,RANDOM_ADDITION),randf_range(-RANDOM_ADDITION,RANDOM_ADDITION))
	
	if team == RoundManager.Team.Chaser:
		return %ChaserSpawn.global_position + variance_vector
	return %RunnerSpawn.global_position + variance_vector
