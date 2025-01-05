extends CharacterBody2D
class_name Player

@export var player_id = 0
@export var is_chaser :bool= false:
	set(value):
		is_chaser = value
		%ChaseHitbox.set_deferred("monitoring",value)

signal player_died(id)


func hit_player(object):
	print("%s got hit by %s" % [player_id, object.name]) 
	if !is_chaser:
		kill_player()
	#else: TODO chasers geraakt door bad stuff? does bad stuff happen?
		#%Movement.add_force(object.PUNCH*(global_position-object.global_position))
		#object.remove()
		## if object in
		## check ofdat de object harmful is aan chasers
		## check de zender ID
		## add force aan speler?
		#pass


func _on_chase_hitbox_body_entered(body: Node2D) -> void:
	if !body.is_chaser:
		body.hit_player(self)
		

func kill_player():
	#TODO omdat er momenteel maar 2 spelers zijn sterft er nooit eigenlijk een speler. 
	# miss ze teleporteren naar een "hell" ofzo in plaats van ze te doden?
	# spawn wa particle effects die ze nalaten
	print("%s: dies" % name)
	player_died.emit(player_id)


func get_team():
	return RoundManager.Team.Chaser if is_chaser else RoundManager.Team.Runner
