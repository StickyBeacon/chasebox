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
				repitch_audio(1)
				%AnimationManager.current_sprites = %WaveSprites
				%WaveSprites.modulate = Color(1,0,0)
				recolor_sprites(Color(1,0,0))
			2:
				repitch_audio(2)
				%AnimationManager.current_sprites = %BratSprites
				%BratSprites.modulate = Color(0,1,0)
				recolor_sprites(Color(0,1,0))
			3:
				repitch_audio(1.5)
				%AnimationManager.current_sprites = %QueenSprites
				%QueenSprites.modulate = Color(0,0,1)
				recolor_sprites(Color(0,0,1))
			4:
				repitch_audio(.66)
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
		%ChaseSprite2.set_deferred("visible",_is_chaser) 


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

var splat_particle = preload("res://spawnables/particles/splatter.tscn")
var splat_sprite = preload("res://spawnables/particles/splat_sprite.tscn")
var win_particle = preload("res://spawnables/particles/win_particles.tscn")
var win_sprite = preload("res://spawnables/particles/win_sprite.tscn")

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
	print("%s: dies" % name)
	%SawSound.play()
	player_died.emit(player_id)
	enabled = false
	
	# particle
	var particle = splat_particle.instantiate()
	particle.global_position = global_position
	particle.modulate = %JumpIndicator.modulate #TODO bruhhh
	get_tree().root.add_child(particle)
	# splat
	for i in randi_range(2,5):
		var splat = splat_sprite.instantiate()
		splat.initialize( %JumpIndicator.modulate, global_position)
		get_tree().get_first_node_in_group("SplatContainer").add_child(splat)
	


func recolor_sprites(color):
	%JumpIndicator.modulate = color
	#%ChaseSprite.modulate = color
	%ChaseSprite.modulate.a = .8
	%ChaseSprite2.modulate = color
	%ChaseSprite2.modulate.a = .3


func repitch_audio(value):
	%JumpSound.pitch_scale = value


func win_round():
	var particle = win_particle.instantiate()
	particle.global_position = global_position
	particle.modulate = %JumpIndicator.modulate #TODO bruhhh
	get_tree().root.add_child(particle)
	
	var win_splat = win_sprite.instantiate()
	win_splat.global_position = global_position
	win_splat.rotation = randf_range(-PI/6,PI/6)
	win_splat.modulate = %JumpIndicator.modulate #TODO bruhhh
	get_tree().get_first_node_in_group("SplatContainer").add_child(win_splat)
