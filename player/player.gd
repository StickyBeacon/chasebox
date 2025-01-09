extends CharacterBody2D
class_name Player

@export var player_id = 0:
	set(value):
		match(value):
			1:
				%PlayerSprite.modulate = Color(1,0,0)
				%JumpIndicator.modulate = Color(1,0,0)
			2:
				%PlayerSprite.modulate = Color(0,1,0)
				%JumpIndicator.modulate = Color(0,1,0)
			3:
				%PlayerSprite.modulate = Color(0,0,1)
				%JumpIndicator.modulate = Color(0,0,1)
			4:
				%PlayerSprite.modulate = Color(1,1,0)
				%JumpIndicator.modulate = Color(1,1,0)
			_:
				printerr("%s: value %s is not valid playerid"% [name, value])
		player_id = value
@export var team :Utils.Team= Utils.Team.Runner:
	set(value):
		team = value
		var _is_chaser = true if value == Utils.Team.Chaser else false
		%ChaseHitbox.set_deferred("monitoring",_is_chaser)
		%ChaseSprite.set_deferred("visible",_is_chaser) 

@export var enabled :bool = false:
	set(value):
		enabled = value
		%Movement.can_move = value
		%PlayerCollision.set_deferred("disabled",!value)
		%ChaseCollision.set_deferred("disabled",!value)
		visible = value


signal player_died(id)


func hit_player(object):
	if !enabled: return
	
	print("%s got hit by %s" % [player_id, object.name]) 
	if team == Utils.Team.Runner:
		_kill_player()
	#else: TODO chasers geraakt door bad stuff? does bad stuff happen?
		#%Movement.add_force(object.PUNCH*(global_position-object.global_position))
		#object.remove()
		## if object in
		## check ofdat de object harmful is aan chasers
		## check de zender ID
		## add force aan speler?
		#pass


func _on_chase_hitbox_body_entered(body: Node2D) -> void:
	if body.team == Utils.Team.Runner:
		body.hit_player(self)
		

func _kill_player():
	#TODO omdat er momenteel maar 2 spelers zijn sterft er nooit eigenlijk een speler. 
	# miss ze teleporteren naar een "hell" ofzo in plaats van ze te doden?
	# spawn wa particle effects die ze nalaten
	print("%s: dies" % name)
	player_died.emit(player_id)
