extends CharacterBody2D
class_name Player

@export var controller_id = 0:
	set(value):
		if not value in [1,2,3,4]:
			printerr("%s: controller id %s not possible" % [name, value])
		controller_id = value
@export var player_id = 0:
	set(value):
		match(value): 
			1:
				%JumpSound.pitch_scale = .9
				%AnimationManager.current_sprites = %WaveSprites
				%WaveSprites.modulate = Color(1,0,0)
				recolor_sprites(Color(1,0,0))
			2:
				%JumpSound.pitch_scale = 1.5
				%AnimationManager.current_sprites = %BratSprites
				%BratSprites.modulate = Color(0,1,0)
				recolor_sprites(Color(0,1,0))
			3:
				%JumpSound.pitch_scale = 1.3
				%AnimationManager.current_sprites = %QueenSprites
				%QueenSprites.modulate = Color(0,0,1)
				recolor_sprites(Color(0,0,1))
			4:
				%JumpSound.pitch_scale = 0.75
				%AnimationManager.current_sprites = %JuliettSprites
				%JuliettSprites.modulate = Color(1,1,0)
				recolor_sprites(Color(1,1,0))
			_:
				printerr("%s: value %s is not valid playerid"% [name, value])
		player_id = value
@export var team :Utils.Team= Utils.Team.Runner:
	set(value):
		team = value
		var _is_chaser = true if value == Utils.Team.Chaser else false
		%ChaseHitbox.set_deferred("monitoring",_is_chaser)
		%ChaseHitbox.set_deferred("visible",_is_chaser) 

@export var enabled :bool = false:
	set(value):
		enabled = value
		%Movement.can_move = value
		%PlayerCollision.set_deferred("disabled",!value)
		%ChaseCollision.set_deferred("disabled",!value)
		visible = value

var handicap:Utils.Handicap = Utils.Handicap.None:
	set(value):
		match(value):
			Utils.Handicap.None: # Nothing
				pass
			Utils.Handicap.SmallerSaw:
				%ChaseHitbox.scale *= .5
			Utils.Handicap.BiggerSaw:
				%ChaseHitbox.scale *= 1.5
			Utils.Handicap.Slowdown:
				%Movement.chaser_extra_speed = -80
			Utils.Handicap.Speedup:
				%Movement.chaser_extra_speed = 220


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
	%SawSound.play()
	player_died.emit(player_id)
	enabled = false


func recolor_sprites(color):
	%JumpIndicator.modulate = color
	%AimCursor.modulate = color
	%ChaseSprite.modulate = color
	%ChaseSprite.modulate.a = .3
	%ChaseSprite2.modulate = color
	%ChaseSprite2.modulate.a = .05
